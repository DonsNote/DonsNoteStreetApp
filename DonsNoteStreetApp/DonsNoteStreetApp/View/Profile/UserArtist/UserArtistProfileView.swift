//
//  UserArtistProfileView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 11/7/23.
//

import SwiftUI

struct UserArtistProfileView: View {
    
    //MARK: -1.PROPERTY
    @EnvironmentObject var service : Service
    @StateObject var viewModel = UserArtistProfileViewModel()
    @Environment(\.dismiss) var dismiss
    
    @Binding var isartistDelete : Bool
    
    //MARK: -2.BODY
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                profileSection
                customDivider()
                firstSection
//                customDivider()
//                secondSection
                customDivider()
                thirdSection
                Spacer()
            }
            .background(backgroundView().ignoresSafeArea())
            .overlay(alignment: .topLeading) {}
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $viewModel.popAddBusking, content: {
                AddBuskingPageView()
            })
        }
    }
}

//MARK: -3.PREVIEW
#Preview {
    UserArtistProfileView(isartistDelete: .constant(true)).environmentObject(Service())
}

//MARK: -4.EXTENSION

extension UserArtistProfileView {
    var profileSection: some View {
        HStack(spacing: UIScreen.getWidth(20)) {
            CircleBlur(image: service.userArtist.artistImageURL, width: 120)
            
            VStack(alignment: .leading) {
                Text(service.userArtist.artistName)
                    .font(.custom20bold())
                Text(service.userArtist.artistInfo)
                    .font(.custom13semibold())
                    .padding(.bottom, UIScreen.getWidth(15))
                HStack{
                    DonationBar()
                }
            }.padding(.top, UIScreen.getWidth(15)).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5))
            Spacer()
        }
        .padding(.init(top: UIScreen.getWidth(40), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(20)))
    }
    
    var firstSection: some View {
        VStack(alignment: .leading) {
            NavigationLink {
                UserArtistPageView()
            } label: {
                Text("아티스트 페이지 관리")
                    .font(.custom13bold())
                    .padding(UIScreen.getWidth(20))
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
            
            NavigationLink {
                AddBuskingPageView()
            } label: {
                Text("공연 등록")
                    .font(.custom13bold())
                    .padding(UIScreen.getWidth(20))
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
            
            NavigationLink {
                EditBuskingView()
            } label: {
                Text("공연 관리")
                    .font(.custom13bold())
                    .padding(UIScreen.getWidth(20))
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
            
//            NavigationLink {
//                EditFanView()
//            } label: {
//                Text("팬 관리")
//                    .font(.custom13bold())
//                    .padding(UIScreen.getWidth(20))
//                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
//            }
//            
//            NavigationLink {
//                EditDonationView()
//            } label: {
//                Text("후원 관리")
//                    .font(.custom13bold())
//                    .padding(UIScreen.getWidth(20))
//                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
//            }
            
        }
    }
    
    
    var secondSection: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $viewModel.switchNotiToggle, label: {
                Text("알림 설정")
                    .font(.custom13bold())
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                
            }) .tint(.cyan.opacity(0.2))
        }.padding(.init(top: UIScreen.getWidth(15), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(15), trailing: UIScreen.getWidth(20)))
    }
    
    
    var thirdSection: some View {
        VStack(alignment: .leading) {
            Button{
                service.getUserProfile()
                dismiss()
            } label: {
                Text("개인 계정 전환")
                    .font(.custom13bold())
                    .padding(UIScreen.getWidth(20))
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
            
            NavigationLink {
                EditUserArtistAcountView(isartistDelete: $isartistDelete)
            } label: {
                Text("아티스트 계정 관리")
                    .font(.custom13bold())
                    .padding(UIScreen.getWidth(20))
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
        }
    }
}
