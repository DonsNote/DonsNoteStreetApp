//
//  EditUserAcountView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import SwiftUI

struct EditUserAcountView: View {
    //MARK: -1.PROPERTY
    @EnvironmentObject var service : Service
//    @EnvironmentObject var appleLogin : AppleLoginViewModel
    
    //MARK: -2.BODY
    var body: some View {
        ZStack(alignment: .topLeading) {
            backgroundView().ignoresSafeArea()
            VStack(alignment: .leading) {
                //로그아웃
                Button {
                    KeychainItem.deleteServerTokenFromKeychain()
                    service.isLogin = false
                    UserDefaults.standard.set(false, forKey: "isLogin")
                } label: {
                    Text("로그아웃")
                        .font(.custom13bold())
                        .padding(UIScreen.getWidth(20))
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
                //탈퇴
                Button {
                    KeychainItem.deleteServerTokenFromKeychain()
                    service.appleRevoke()
                } label: {
                    Text("탈퇴")
                        .foregroundStyle(Color(appRed))
                        .font(.custom13bold())
                        .padding(UIScreen.getWidth(20))
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
            }.padding(.top, UIScreen.getHeight(100))
        }
    }
}

#Preview {
    EditUserAcountView()
}
