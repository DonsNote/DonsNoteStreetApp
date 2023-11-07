//
//  AppleLoginView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginView: View {
    var body: some View {
        VStack {
            AppleSigninButton()
        }
        .frame(height:UIScreen.main.bounds.height)
        .background(Color.white)
    }
}

struct AppleSigninButton : View {
    
    @EnvironmentObject var service : Service
    
    var body: some View {
        SignInWithAppleButton (
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    switch authResults.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential :
                        let AuthorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                        do {
                            service.appleSign(authCode: AuthorizationCode ?? "")
                        }
                    default:
                        break
                    }
                case .failure(let error):
                    print("AppleSigninButton.error : \(error.localizedDescription)")
                }
            }
        )
        .frame(width : UIScreen.main.bounds.width * 0.9, height:50)
        .cornerRadius(5)
    }
}

#Preview {
    AppleLoginView()
}
