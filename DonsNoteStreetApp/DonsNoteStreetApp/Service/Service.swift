//
//  Service.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import Foundation
import SwiftUI
import Alamofire

class Service : ObservableObject {
    
    let serverDomain : String = "https://aesopos.co.kr/"
    
    @Published var serverToken : String? = KeychainItem.currentServerToken
    @Published var refreshToken : String? = KeychainItem.currentRefreshToken
    @Published var isLogin : Bool = UserDefaults.standard.bool(forKey: "isLogin")
    
    @Published var report : String = ""
    @Published var user : User = User()
    @Published var userArtist : Artist = Artist()
    @Published var busking : Busking = Busking()
    @Published var myBusking : [Busking] = []
    
    @Published var myArtist : [Artist] = []
    @Published var targetArtist : Artist = Artist()
    @Published var blockList : [Artist] = []
    @Published var myArtistBusking : [Busking] = []
    @Published var nowBusking : [Busking] = []
    @Published var myArtistBuskingInt : [Int] = []
    
    @Published var allArtist : [Artist] = []
    @Published var allBusking : [Busking] = []
    
    @Published var croppedImage : UIImage?
    @Published var userArtistCroppedImage : UIImage?
    @Published var patchUserArtistCroppedImage : UIImage?
    
    enum UsernameStatus {
        case empty
        case duplicated
        case available
    }
    
    
    func appleSign(uid: String, authCode: String) {
        let parameters: [String: String] = [
            "uid" : uid,
            "code" : authCode
        ]
        AF.request("\(serverDomain)auth/apple-login", method: .post, parameters: parameters)
            .responseDecodable(of: SignResponse.self) { response in
                switch response.result {
                case .success(let reData):
                    do {
                        try KeychainItem(service: "DonsNote.DonsNoteStreetApp", account: "ServerToken").saveItem(reData.token)
                        try KeychainItem(service: "DonsNote.DonsNoteStreetApp", account: "RefreshToken").saveItem(reData.retoken)
                    } catch {
                        print("Token Response on Keychain is fail")
                    }
                    self.serverToken = reData.token
                    self.refreshToken = reData.retoken
                    self.getUserProfile()
                    self.isLogin = true
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    print("Apple Login Success")
//                    print("Check for Session ST : \(self.serverToken)")
                case .failure(let error):
                    self.isLogin = false
                    UserDefaults.standard.set(false, forKey: "isLogin")
                    print("Error : \(error)")
                }
            }
    }
    
    func appleRevoke() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        AF.request("\(serverDomain)auth/apple-revoke", method: .post, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    self.isLogin = false
                    UserDefaults.standard.set(false, forKey: "isLogin")
                    KeychainItem.deleteServerTokenFromKeychain()
                    KeychainItem.deleteRefreshTokenFromKeychain()
                    print("Apple Logout Success")
                case .failure(let error):
                    self.isLogin = false
                    UserDefaults.standard.set(false, forKey: "isLogin")
                    print("Error : \(error)")
                }
            }
    }
    
    func extToken() {
        let headers: HTTPHeaders = [.authorization(bearerToken: refreshToken ?? "")]
        AF.request("\(serverDomain)auth/token", method: .get, headers: headers)
            .responseDecodable(of: SignResponse.self) { response in
                switch response.result {
                case .success(let reData):
                    do {
                        try KeychainItem(service: "DonsNote.DonsNoteStreetApp", account: "ServerToken").saveItem(reData.token)
                        try KeychainItem(service: "DonsNote.DonsNoteStreetApp", account: "RefreshToken").saveItem(reData.retoken)
                    } catch {
                        print("Token Response on Keychain is fail")
                    }
                    self.serverToken = reData.token
                    self.refreshToken = reData.retoken
                    print("Access Token Refreash Success")
                case .failure(let error):
                    print("Error : \(error)")
                }
            }
    }
    
    func report(artistId : Int) {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        let parameters: [String: Any] = [
            "userId" : self.user.id,
            "artistId" : artistId,
            "report" : self.report
        ]
        
        AF.request("\(serverDomain)report/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    self.block(artistId: artistId)
                    print("Post Report Success")
                case .failure(let error):
                    print("Post Report fail Error : \(error)")
                }
            }
    }
    
    func getUserProfile() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        AF.request("\(serverDomain)users/", method: .get, headers: headers)
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let userProfile):
                    self.user = userProfile
                    print("Get User Profile Success")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            self.extToken()
                        default:
                            print("Error: \(error)")
                        }
                    } else {
                        print("Error: \(error)")
                    }
                }
            }
    }
    
    func patchUserProfile() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        let parameters: [String: String] = [
            "userName" : self.user.userName,
            "userInfo" : self.user.userInfo
        ]
        AF.upload(multipartFormData: { multipartFormData in
            if let imageData = self.croppedImage?.jpegData(compressionQuality: 1) {
                multipartFormData.append(imageData, withName: "image", fileName: "avatar.jpg", mimeType: "image/jpeg")
            }
            else if let defaultImageData = UIImage(named: "Default")?.jpegData(compressionQuality: 1) {
                multipartFormData.append(defaultImageData, withName: "image", fileName: "avatar.jpg", mimeType: "image/jpeg")
            }
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: "\(serverDomain)users/", method: .patch, headers: headers)
        .response { response in
            switch response.result {
            case .success:
                self.getUserProfile()
                print("User Profile Update Success!")
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 401:
                        self.extToken()
                    default:
                        print("Error: \(error)")
                    }
                } else {
                    print("Error : \(error.localizedDescription)")
                }
            }
        }
    }
    
    func postUserArtist() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        let parameters: [String: String] = [
            "artistName" : self.userArtist.artistName,
            "artistInfo" : self.userArtist.artistInfo,
            "genres" : self.userArtist.genres ?? "",
            "youtubeURL" : self.userArtist.youtubeURL ?? "",
            "instagramURL" : self.userArtist.instagramURL ?? "",
            "soundcloudURL" : self.userArtist.soundcloudURL ?? ""
        ]
        AF.upload(multipartFormData: { multipartFormData in
            if let imageData = self.userArtistCroppedImage?.jpegData(compressionQuality: 1) {
                multipartFormData.append(imageData, withName: "image", fileName: "artist.jpg", mimeType: "image/jpeg")
            }
            else if let defaultImageData = UIImage(named: "Default")?.jpegData(compressionQuality: 1) {
                multipartFormData.append(defaultImageData, withName: "image", fileName: "artist.jpg", mimeType: "image/jpeg")
            }
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: "\(serverDomain)artists/", method: .post, headers: headers)
        .responseDecodable(of: Artist.self) { response in
            switch response.result {
            case .success(let reData):
                self.userArtist = reData
                self.getUserProfile()
                print("Post User Artist Profile Success!")
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 401:
                        self.extToken()
                    default:
                        print("Error: \(error)")
                    }
                } else {
                    print("Error : \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getUserArtistProfile() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        AF.request("\(serverDomain)artists/", method: .get, headers: headers)
            .responseDecodable(of: Artist.self) { response in
                switch response.result {
                case .success(let reData):
                    self.userArtist = reData
                    print("Get User Artist Profile Success")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            self.extToken()
                        default:
                            print("Error: \(error)")
                        }
                    } else {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func patchUserArtistProfile() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        let parameters: [String: String] = [
            "artistName" : self.userArtist.artistName,
            "artistInfo" : self.userArtist.artistInfo,
            "genres" : self.userArtist.genres ?? "",
            "youtubeURL" : self.userArtist.youtubeURL ?? "",
            "instagramURL" : self.userArtist.instagramURL ?? "",
            "soundcloudURL" : self.userArtist.soundcloudURL ?? ""
        ]
        AF.upload(multipartFormData: { multipartFormData in
            if let imageData = self.patchUserArtistCroppedImage?.jpegData(compressionQuality: 1) {
                multipartFormData.append(imageData, withName: "image", fileName: "avatar.jpg", mimeType: "image/jpeg")
            }
            else if let defaultImageData = UIImage(named: "Default")?.jpegData(compressionQuality: 1) {
                multipartFormData.append(defaultImageData, withName: "image", fileName: "avatar.jpg", mimeType: "image/jpeg")
            }
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: "\(serverDomain)artists/", method: .patch, headers: headers)
        .response { response in
            switch response.result {
            case .success:
                self.getUserArtistProfile()
                print("User Artist Profile Update Success!")
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 401:
                        self.extToken()
                    default:
                        print("Error: \(error)")
                    }
                } else {
                    print("Error : \(error.localizedDescription)")
                }
            }
        }
    }
    
    func deleteUserArtist() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        AF.request("\(serverDomain)artists/", method: .delete, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    self.getUserProfile()
                    print("Delete User Artist Acount Success")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            self.extToken()
                        default:
                            print("Error: \(error)")
                        }
                    } else {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func follow(artistId : Int) {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        let parameters: [String : Int] = [
            "artistId" : artistId
        ]
        AF.request("\(serverDomain)users/follow/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    self.getUserProfile()
                    self.getMyArtist()
                    print("Followed Success")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            self.extToken()
                        default:
                            print("Error: \(error)")
                        }
                    } else {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func unfollow(artistId : Int) {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        let parameters: [String: Int] = [
            "artistId" : artistId
        ]
        AF.request("\(serverDomain)users/unfollow/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    self.getUserProfile()
                    self.getMyArtist()
                    print("Unfollow Success")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            self.extToken()
                        default:
                            print("Error: \(error)")
                        }
                    } else {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func block(artistId : Int) {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        let parameters: [String : Int] = [
            "artistId" : artistId
        ]
        AF.request("\(serverDomain)users/block/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    self.getUserProfile()
                    self.getAllArtist()
                    self.getMyArtist()
                    print("Blocked Success")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            self.extToken()
                        default:
                            print("Error: \(error)")
                        }
                    } else {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func unblock(artistId : Int) {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        let parameters: [String : Int] = [
            "artistId" : artistId
        ]
        AF.request("\(serverDomain)users/unblock/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    self.getUserProfile()
                    self.getBlockList()
                    print("Unblocked Success")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            self.extToken()
                        default:
                            print("Error: \(error)")
                        }
                    } else {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func getBlockList() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        AF.request("\(serverDomain)artists/blockList/", method: .get, headers: headers)
            .responseDecodable(of: [Artist].self) { response in
                switch response.result {
                case .success(let reData):
                    self.blockList = reData
                    print("Get Block List Success")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            self.extToken()
                        default:
                            print("Error: \(error)")
                        }
                    } else {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func getTargetArtist(artistId : Int) {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        let parameters: [String: Int] = [
            "artistId" : artistId
        ]
        AF.request("\(serverDomain)artists/target/", method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: Artist.self) { response in
                switch response.result {
                case .success(let reData):
                    self.targetArtist = reData
                    print("Get Target Artist Profile Success")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            self.extToken()
                        default:
                            print("Error: \(error)")
                        }
                    } else {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func getAllArtist() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        AF.request("\(serverDomain)artists/all/", method: .get, headers: headers)
            .responseDecodable(of: [Artist].self) { response in
                switch response.result {
                case .success(let reData):
                    let blockedArtistIds = Set(self.user.block)
                    let followedArtistIds = Set(self.user.follow)
                    self.allArtist = reData.filter { artist in !blockedArtistIds.contains(artist.id) && !followedArtistIds.contains(artist.id) }
                    print("Get All Artist Profile Success")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            self.extToken()
                        default:
                            print("Error: \(error)")
                        }
                    } else {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
        
    }
    
    func getMyArtist() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        AF.request("\(serverDomain)artists/myArt/", method: .get, headers: headers)
            .responseDecodable(of: [Artist].self) { response in
                switch response.result {
                case .success(let reData):
                    let blockedArtistIds = Set(self.user.block)
                    self.myArtist = reData.filter { !blockedArtistIds.contains($0.id) }
                    self.myArtistBuskingInt = self.myArtist.flatMap {$0.buskings ?? []}
                    self.getMyArtistBusking()
                    print("Get My Artist Profile Success")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            self.extToken()
                        default:
                            print("Error: \(error)")
                        }
                    } else {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func postBusking() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let StartTime = dateFormatter.string(from: self.busking.startTime)
        let EndTime = dateFormatter.string(from: self.busking.endTime)
        let parameters: [String: Any] = [
            "buskingName" : self.userArtist.artistName,
            "buskingInfo" : self.userArtist.artistName,
//            "buskingInfo" : self.busking.buskingInfo,
            "latitude" : self.busking.latitude,
            "longitude" : self.busking.longitude,
            "startTime" : StartTime,
            "endTime" : EndTime
            
        ]
        AF.request("\(serverDomain)buskings/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                switch response.result {
                case .success :
                    self.getMyBusking()
                    print("Post Busking Success")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            self.extToken()
                        default:
                            print("Error: \(error)")
                        }
                    } else {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func getMyBusking() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let parameters: [String: [Int]] = [
            "buskingsId" : self.userArtist.buskings ?? []
        ]
        AF.request("\(serverDomain)buskings/myBusking/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: [Busking].self, decoder: decoder) { response in
                switch response.result {
                case .success(let reData):
                    self.myBusking = reData
                    print("Get My Busking Success")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            self.extToken()
                        default:
                            print("Error: \(error)")
                        }
                    } else {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func getNowBusking() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        AF.request("\(serverDomain)buskings/now/", method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: [Busking].self, decoder: decoder) { response in
                switch response.result {
                case .success(let reData):
                    let blockedArtistIds = Set(self.user.block)
                    self.nowBusking = reData.filter { !blockedArtistIds.contains($0.artistId) }
                    print("Get Now Busking Success : \(self.nowBusking)")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            self.extToken()
                        default:
                            print("Error: \(error)")
                        }
                    } else {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func getAllBuskings() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        AF.request("\(serverDomain)buskings/all/", method: .get, headers: headers)
            .responseDecodable(of: [Busking].self, decoder: decoder) { response in
                switch response.result {
                case .success(let reData):
                    let blockedArtistIds = Set(self.user.block)
                    self.allBusking = reData.filter { !blockedArtistIds.contains($0.artistId) }
                    print("Get All Busking Success")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            self.extToken()
                        default:
                            print("Error: \(error)")
                        }
                    } else {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func getMyArtistBusking() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let parameters: [String: [Int]] = [
            "buskingsId" : myArtistBuskingInt
        ]
        AF.request("\(serverDomain)buskings/myArtBusking/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: [Busking].self, decoder: decoder) { response in
                switch response.result {
                case .success(let reData):
                    self.myArtistBusking = reData
                    print("Get My Artist Busking Success")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            self.extToken()
                        default:
                            print("Error: \(error)")
                        }
                    } else {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func deleteBusking(buskingId : Int) {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        
        let parameters : [String : Int] = [
            "buskingId" : buskingId
        ]
        AF.request("\(serverDomain)buskings/", method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    self.getMyBusking()
                    print("Delete Busking Success")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            self.extToken()
                        default:
                            print("Error: \(error)")
                        }
                    } else {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
    }
    
}
