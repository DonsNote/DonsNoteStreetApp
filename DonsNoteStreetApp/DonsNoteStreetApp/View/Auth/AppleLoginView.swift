//
//  LoginView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    var body: some View {
        VStack {
            AppleSigninButton()
        }.frame(height:UIScreen.main.bounds.height).background(Color.white)
    }
}

struct AppleSigninButton : View{
    
    @EnvironmentObject var userAuth : AppleLoginViewModel
    
    var body: some View{
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    print("Apple Login Successful")
                    switch authResults.credential{
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        // 계정 정보 가져오기
                        let UserIdentifier = appleIDCredential.user
//                        let fullName = appleIDCredential.fullName
//                        let name =  (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
//                        let email = appleIDCredential.email
                        let IdentityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
//                        let AuthorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                        do {
                            try KeychainItem(service: "DonsNote.DonsNoteStreetApp", account: "userIdentifier").saveItem(UserIdentifier)
                            try KeychainItem(service: "DonsNote.DonsNoteStreetApp", account: "IdentityToken").saveItem(IdentityToken ?? "")
                            userAuth.showLoginView = false
                        } catch {
                            print("AppleSigninButton.error : Unable to save userIdentifier to keychain.")
                        }
                    default:
                        break
                    }
                case .failure(let error):
                    print("AppleSigninButton.error : \(error.localizedDescription)")
                }
            }
        )
        .frame(height:UIScreen.getHeight(50))
        .cornerRadius(UIScreen.getHeight(25))
    }
}

#Preview {
    LoginView()
}
