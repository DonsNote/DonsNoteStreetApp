//
//  AppleLoginView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginView: View {
//MARK: - 1. PROPERTY
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
        VStack {
            Spacer()
            Spacer()
            Image("pin")
                .resizable()
                .scaledToFit()
                .frame(width :UIScreen.getWidth(100))
                .shadow(color: .black.opacity(0.3),radius: UIScreen.getWidth(8))
//            Text("Yonder")
//                .font(.custom40black()).foregroundColor(.appIndigo2)
//                .padding(.horizontal,UIScreen.getWidth(20))
//                .padding(.vertical, UIScreen.getWidth(1))
//                .background{
//                    Capsule().stroke(Color.appIndigo2, lineWidth: 7)}
//                .shadow(color: .black.opacity(0.15) ,radius: UIScreen.getWidth(10))
            Spacer()
            SignInWithAppleButton (
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        switch authResults.credential {
                        case let appleIDCredential as ASAuthorizationAppleIDCredential :
                            let UID = appleIDCredential.user
                            let AuthorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                            do {
                                service.appleSign(uid: UID, authCode: AuthorizationCode ?? "")
                            }
                        default:
                            break
                        }
                    case .failure(let error):
                        print("AppleSigninButton.error : \(error.localizedDescription)")
                    }
                }
            )
            .signInWithAppleButtonStyle(.white)
            .frame(height: UIScreen.getHeight(50))
            .clipShape(Capsule())
            .padding(.horizontal, 10)
            Spacer()
        }
    }
}

#Preview {
    AppleLoginView()
}
