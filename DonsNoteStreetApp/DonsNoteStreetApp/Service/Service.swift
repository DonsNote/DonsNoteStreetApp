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
    
    @Published var serverToken : String? = KeychainItem.currentServerToken
    @Published var refreshToken : String? = KeychainItem.currentRefreshToken
    @Published var isLogin : Bool = UserDefaults.standard.bool(forKey: "isLogin")
    
    @Published var user : User = User()
    @Published var userArtist : Artist = Artist()
    @Published var myArtist : [Artist] = []
    @Published var croppedImage : UIImage?
    @Published var userArtistCroppedImage : UIImage?
    @Published var patchUserArtistCroppedImage : UIImage?
    
    enum UsernameStatus {
        case empty
        case duplicated
        case available
    }
    
    
    func appleSign(authCode: String) {
        let parameters: [String: String] = [
            "code" : authCode
        ]
        AF.request("https://aesopos.co.kr/auth/apple-login", method: .post, parameters: parameters)
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
                    print(reData.token)
                    print("Apple Login Success")
                case .failure(let error):
                    self.isLogin = false
                    UserDefaults.standard.set(false, forKey: "isLogin")
                    print("Error : \(error)")
                }
            }
    }
    
    func appleRevoke() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        AF.request("https://aesopos.co.kr/auth/apple-revoke", method: .post, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    print("Apple Logout Success")
                    self.isLogin = false
                    UserDefaults.standard.set(false, forKey: "isLogin")
                    KeychainItem.deleteServerTokenFromKeychain()
                    KeychainItem.deleteRefreshTokenFromKeychain()
                case .failure(let error):
                    self.isLogin = false
                    UserDefaults.standard.set(false, forKey: "isLogin")
                    print("Error : \(error)")
                }
            }
    }
    
    func extToken() {
        let headers: HTTPHeaders = [.authorization(bearerToken: refreshToken ?? "")]
        AF.request("https://aesopos.co.kr/auth/token", method: .get, headers: headers)
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
                    print("Apple Login Success")
                case .failure(let error):
                    print("Error : \(error)")
                }
            }
    }
    
    func getUserProfile() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        AF.request("https://aesopos.co.kr/users/", method: .get, headers: headers)
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let userProfile):
                    self.user = userProfile
                    print("Get User Profile Success")
                    print("UserProfile : \(userProfile)")
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
        }, to: "https://aesopos.co.kr/users/", method: .patch, headers: headers)
        .response { response in
            switch response.result {
            case .success:
                self.getUserProfile()
                print("User Profile Update Success!")
            case .failure(let error):
                print("Error : \(error.localizedDescription)")
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
        }, to: "https://aesopos.co.kr/artists/", method: .post, headers: headers)
        .responseDecodable(of: Artist.self) { response in
            switch response.result {
            case .success(let reData):
                self.userArtist = reData
                self.getUserProfile()
                print(reData)
                print("Post User Artist Profile Success!")
            case .failure(let error):
                print("Error : \(error.localizedDescription)")
            }
        }
    }
    
    func getUserArtistProfile() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        AF.request("https://aesopos.co.kr/artists/", method: .get, headers: headers)
            .responseDecodable(of: Artist.self) { response in
                switch response.result {
                case .success(let reData):
                    self.userArtist = reData
                    print(reData)
                    print("Get User Artist Profile Success")
                case .failure(let error):
                    print("Error : \(error)")
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
        }, to: "https://aesopos.co.kr/artists/", method: .patch, headers: headers)
        .response { response in
            switch response.result {
            case .success:
                self.getUserArtistProfile()
                print("User Profile Update Success!")
            case .failure(let error):
                print("Error : \(error.localizedDescription)")
            }
        }
    }
    
    func deleteUserArtist() {
        let headers: HTTPHeaders = [.authorization(bearerToken: serverToken ?? "")]
        AF.request("https://aesopos.co.kr/artists/", method: .delete, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    self.getUserArtistProfile()
                    print("Delete User Artist Acount Success")
                case .failure(let error):
                    print("Error : \(error)")
                }
            }
    }
    
}
