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
    
    @Published var accesseToken : String? = KeychainItem.currentTokenResponse
    @Published var isSignIn : Bool = UserDefaults.standard.bool(forKey: "isSignIn")
    @Published var isCreatUserArtist: Bool = UserDefaults.standard.bool(forKey: "isCreatUserArtist")
    
    @Published var user : User = User()
    @Published var myArtist : [Artist] = []
    @Published var allArtist : [Artist] = []
    @Published var addBusking : Busking = Busking()
    
    @Published var croppedImage : UIImage?
    
    
    @Published var usernameStatus: UsernameStatus = .empty
    enum UsernameStatus {
        case empty
        case duplicated
        case available
    }
    
    
    //Get User Profile
    func getUserProfile(completion: @escaping () -> Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        AF.request("http://localhost:3000/auth/profile", method: .post, headers: headers)
            .validate()
            .responseDecodable(of: User.self, decoder: decoder) { response in
                switch response.result {
                case .success(let userData) :
                    self.user = userData
                    print("Get User Profile Success!")
                case .failure(let error) :
                    print("Error : \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    //Add UserProfile
    func postUserProfile(completion: @escaping () -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let parameters: [String: String] = [
            "userName" : self.user.userName,
            "userInfo" : self.user.userInfo
        ]
        
        if !user.userName.isEmpty && !user.userInfo.isEmpty {
            AF.upload(multipartFormData: { multipartFormData in
                if let imageData = self.croppedImage?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(imageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
                else if let defaultImageData = UIImage(named: "default")?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(defaultImageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            }, to: "http://localhost:3000/auth/signup-with-image", method: .post)
            .responseDecodable(of: User.self, decoder: decoder) { response in
                switch response.result {
                case .success:
                    print("SignUp Success!")
                    self.user = User()
                case .failure(let error):
                    print("postUserProfile.error : \(error.localizedDescription)")
                }
                completion()
            }
        }
    }
    
    //Login for get Token //배치완료
//    func SignIn() {
//        let parameters: [String : String] = [
//            "email": self.user.email,
//            "password": self.user.password
//        ]
//        AF.request("http://localhost:3000/auth/signin", method: .post, parameters: parameters)
//            .responseDecodable(of: TokenResponse.self) { response in
//                switch response.result {
//                case .success(let tokenResponse):
//                    self.accesseToken = tokenResponse.accessToken
//                    do {
//                        try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "tokenResponse").saveItem(tokenResponse.accessToken) //키체인에 토큰 등록
//                    } catch {
//                        print("testSignIn.Error saving token to keychain: \(error.localizedDescription)")
//                    }
//                    self.isSignIn = true
//                    UserDefaults.standard.set(true ,forKey: "isSignIn")
//                    print("SignIn Success!")
//                case .failure(let error):
//                    print("Error: \(error.localizedDescription)")
//                }
//            }
//    }
    
    //Edit UserProfile
    func patchUserProfile() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let parameters: [String: String] = [
            "userName" : self.user.userName,
            "userInfo" : self.user.userInfo
        ]
        if !user.userName.isEmpty && !user.userInfo.isEmpty {
            AF.upload(multipartFormData: { multipartFormData in
                if let imageData = self.croppedImage?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(imageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
                else if let defaultImageData = UIImage(named: "default")?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(defaultImageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            }, to: "http://localhost:3000/auth/\(self.user.id)", method: .patch)
            .responseDecodable(of: User.self, decoder: decoder) { response in
                switch response.result {
                case .success(let patchData):
                    self.user = patchData
                    print("User Profile Update Success!")
                case .failure(let error):
                    print("Error : \(error.localizedDescription)")
                }
            }
        }
    }
    
    //Add Follow
    func follow(artistid : Int, completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/user-following/\(self.user.id)/follow/\(artistid)", method: .post)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    self.getMyArtistList {}
                    print("following.success")
                case .failure(let error) :
                    print("following.error: \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    //Following List
    func getMyArtistList(completion: @escaping () -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        AF.request("http://localhost:3000/user-following/\(self.user.id)/following", method: .get)
            .validate()
            .responseDecodable(of: [Artist].self, decoder: decoder) { response in
                switch response.result {
                case .success(let followingData) :
                    self.myArtist = followingData
                    print("Get My Artist List, Success")
                case .failure(let error) :
                    print("getFollowingList.error : \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    //UnFollow
    func unFollow(artistid : Int, completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/user-following/\(self.user.id)/unfollow/\(artistid)", method: .delete)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                self.getMyArtistList {}
                    print("unfollow success")
                case .failure(let error) :
                    print("unfollowing.error : \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    //Delete User Acount //배치완료
    func deleteUser() {
        AF.request("http://localhost:3000/auth/\(self.user.id)", method: .delete)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    self.isSignIn = false
                    UserDefaults.standard.set(false, forKey: "isSignIn")
                    try? KeychainItem(service: "DonsNote.DonsNoteStreetApp", account: "tokenResponse").deleteItem()
                    print("DeleteUser.success!")
                case .failure(let error) :
                    print("Error : \(error.localizedDescription)")
                }
            }
    }
    
    //Add User Artist //
    func postUserArtist(completion: @escaping () -> Void) {
        
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        let parameters: [String: String] = [
            "userArtistName" : self.user.userArtist?.artistName ?? "",
            "userArtistInfo" : self.user.userArtist?.artistInfo ?? "",
            "genres" : self.user.userArtist?.genres ?? "",
            "youtubeURL" : self.user.userArtist?.youtubeURL ?? "",
            "instagramURL" : self.user.userArtist?.instagramURL ?? "",
            "soundcloudURL" : self.user.userArtist?.soundcloudURL ?? ""
        ]
        
        if ((user.userArtist?.artistName.isEmpty) == nil) && ((user.userArtist?.genres.isEmpty) == nil) && ((user.userArtist?.artistInfo.isEmpty) == nil) {
            AF.upload(multipartFormData: { multipartFormData in
                if let imageData = self.croppedImage?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(imageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
                else if let defaultImageData = UIImage(named: "UserBlank")?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(defaultImageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            }, to: "http://localhost:3000/artist-POST/create", method: .post, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    self.isCreatUserArtist = true
                    UserDefaults.standard.set(true ,forKey: "isCreatUserArtist")
                    self.getUserProfile {
                    print("postUserArtist.success")
                    }
                case .failure(let error):
                    print("postUserArtist.error : \(error.localizedDescription)")
                }
            }
            completion()
        }
    }
    
    //Get User Artist Profilfe // 일단 지금 안쓸듯
    func getUserArtistProfile(completion: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        AF.request("http://localhost:3000/artist/\(self.user.id)", method: .get)
            .validate()
            .responseDecodable(of: Artist.self, decoder: decoder) { response in
                switch response.result {
                case .success(let userArtistData) :
                    self.user.userArtist = userArtistData
                    print("getUserArtistProfile.userArtistdata : \(userArtistData)")
                case .failure(let error) :
                    print("getUserArtistProfile.error : \(error)")
                }
                completion()
            }
    }
    
    //Patch User Artist
    func patchUserArtistProfile(completion: @escaping () -> Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        let parameters: [String: String] = [
            "artistName" : self.user.userArtist?.artistName ?? "",
            "artistInfo" : self.user.userArtist?.artistInfo ?? "",
            "genres" : self.user.userArtist?.genres ?? "",
            "youtubeURL" : self.user.userArtist?.youtubeURL ?? "",
            "instagramURL" : self.user.userArtist?.instagramURL ?? "",
            "soundcloudURL" : self.user.userArtist?.soundcloudURL ?? ""
        ]
        
            AF.upload(multipartFormData: { multipartFormData in
                if let imageData = self.croppedImage?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(imageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
                else if let defaultImageData = UIImage(named: "default")?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(defaultImageData, withName: "images", fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            }, to: "http://localhost:3000/artist/update/\(self.user.userArtist?.id ?? 0)", method: .patch, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    self.getUserProfile {
                        print("PatchUserArtist.success")
                    }
                case .failure(let error):
                    print("postUserArtist.error : \(error.localizedDescription)")
                }
            }
            completion()
    }
    
    //Delete User Artist
    func deleteUserArtist() {
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        AF.request("http://localhost:3000/artist/\(self.user.userArtist?.id ?? 0)", method: .delete, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success :
                    print("User Artist Delete Success!")
                case .failure(let error) :
                    print("Error : \(error)")
                }
            }
    }
    
    //Get All Artist List //배치완료
    func getAllArtistList(completion: @escaping () -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        AF.request("http://localhost:3000/artist/All", method: .get)
            .validate()
            .responseDecodable(of: [Artist].self,decoder: decoder) { response in
                switch response.result {
                case .success(let allArtistData) :
                    self.allArtist = allArtistData
                    print("Get all Artist Success!")
                case .failure(let error) :
                    print("getAllArtistList.error : \(error.localizedDescription)")
                }
                completion()
            }
    }
    
    //Add Busking
    func postBusking() {
        
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let parameters: [String: Any] = [
            
            "buskingInfo" : self.addBusking.buskingInfo,
            "startTime" : self.addBusking.startTime,
            "endTime" : self.addBusking.endTime,
            "latitude" : self.addBusking.latitude,
            "longitudde" : self.addBusking.longitude
        ]
        
        AF.request("http://localhost:3000/busking/register/\(self.user.userArtist?.id ?? 0)", method: .post, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: Busking.self ,decoder: decoder) { response in
                switch response.result {
                case .success :
                    print("postBusking.success")
                case .failure(let error) :
                    print("postBusking.error : \(error.localizedDescription)")
                }
            }
    }
    
    //Get My Busking List //??
    func getMyBuskingList() {
        
        let headers: HTTPHeaders = [.authorization(bearerToken: accesseToken ?? "")]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        AF.request("http://localhost:3000/busking/getAll/\(self.user.userArtist?.id ?? 0)", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [Busking].self, decoder: decoder) { response in
                switch response.result {
                case .success(let myBuskingData) :
                    self.user.userArtist?.buskings = myBuskingData
                    print("GetMyBuskingList.Success!")
                case .failure(let error) :
                    print("getMyBuskingList.error : \(error.localizedDescription)")
                }
            }
    }
}
