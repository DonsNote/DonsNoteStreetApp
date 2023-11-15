//
//  ProfileView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import SwiftUI

struct ProfileView: View {
//MARK: -1.PROPERTY
    
    @EnvironmentObject var service : Service
    @StateObject var viewModel = ProfileViewModel()
    @State var isartistDelete : Bool = false
    @State var popAddUserArtistView : Bool = false
    
//MARK: -2.BODY
    
    var body: some View {
        NavigationView() {
            VStack(alignment: .leading) {
                
                profileSection
                customDivider()
                profileSetting
                artistSetting
                blockSetting
                customDivider()
                artistAccount
                accountSetting
                Spacer()
                
            }
            .background(backgroundView().ignoresSafeArea())
            .navigationTitle("")
        }
        .fullScreenCover(isPresented: $isartistDelete) {UserArtistProfileView(isartistDelete: $isartistDelete)}
        .fullScreenCover(isPresented: $popAddUserArtistView, onDismiss: onDismiss) { AddUserArtistView() }
    }
}

//MARK: -3.EXTENSION

extension ProfileView {
    
    var profileSection: some View {
        HStack(spacing: UIScreen.getWidth(20)) {
            CircleBlur(image: service.user.userImageURL, width: 120)
            VStack(alignment: .leading) {
                HStack{
                    Image(systemName: "person.circle.fill").font(.custom18semibold())
                    Text(service.user.userName).font(.custom21black())
                }
                    .padding(.bottom, UIScreen.getWidth(15))
            }.padding(.top, UIScreen.getWidth(15)).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5))
            Spacer()
        }.padding(.init(top: UIScreen.getWidth(30), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(20)))
    }
    
    var profileSetting: some View {
        NavigationLink {
            UserPageView()
        } label: {
            Text("프로필 관리")
                .font(.custom13bold())
                .padding(UIScreen.getWidth(20))
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }
    }
    
    var artistSetting: some View {
        NavigationLink {
            EditFollowingListView()
        } label: {
            Text("아티스트 관리")
                .font(.custom13bold())
                .padding(UIScreen.getWidth(20))
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }
    }
    
    var blockSetting: some View {
        NavigationLink {
            EditBlockListView()
        } label: {
            Text("차단 관리")
                .font(.custom13bold())
                .padding(UIScreen.getWidth(20))
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }
    }
    
    var notificationSetting: some View {
        Toggle(isOn: $viewModel.switchNotiToggle, label: {
            Text("알림 설정")
                .font(.custom13bold())
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }).padding(.init(top: UIScreen.getWidth(15), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(15), trailing: UIScreen.getWidth(20)))
            .tint(.cyan.opacity(0.4))
        
    }
    
    var artistAccount: some View {
        VStack(spacing: 0) {
            if service.user.artistId ?? 0 > 0 {
                Button {
                    service.getUserArtistProfile()
                    isartistDelete = true
                } label: {
                    Text("아티스트 계정 전환")
                        .font(.custom13bold())
                        .padding(UIScreen.getWidth(20))
                        .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                }
            } else {
                Button {
                    popAddUserArtistView = true
                } label: {
                    Text("아티스트 계정 등록")
                        .font(.custom13bold())
                        .padding(UIScreen.getWidth(20))
                        .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                }
            }
        }
    }
    
    var accountSetting: some View {
        NavigationLink {
            EditUserAcountView()
        } label: {
            Text("계정 관리")
                .font(.custom13bold())
                .padding(UIScreen.getWidth(20))
        }
    }
    
    func onDismiss() {
        popAddUserArtistView = false
    }
}

//MARK: -4.PREVIEW

#Preview {
    ProfileView().environmentObject(Service())
}
