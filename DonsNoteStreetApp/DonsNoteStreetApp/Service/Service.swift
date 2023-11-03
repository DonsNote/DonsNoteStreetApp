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
    @Published var isLogin : Bool = UserDefaults.standard.bool(forKey: "isLogin")
    
    @Published var user : User = User()
    @Published var userArtist : Artist = Artist()
    @Published var myArtist : [Artist] = []
    @Published var croppedImage : UIImage?
    
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
                case .success(let reToken):
                    do {
                        try KeychainItem(service: "DonsNote.DonsNoteStreetApp", account: "ServerToken").saveItem(reToken.token)
                    } catch {
                        print("Token Response on Keychain is fail")
                    }
                    self.isLogin = true
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    print("Apple Login Success")
                    print("ServerToken: \(reToken)")
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
                    self.isLogin = false
                    UserDefaults.standard.set(false, forKey: "isLogin")
                    print("Apple Login Success")
                case .failure(let error):
                    self.isLogin = false
                    UserDefaults.standard.set(false, forKey: "isLogin")
                    print("Error : \(error)")
                }
            }
    }
}
