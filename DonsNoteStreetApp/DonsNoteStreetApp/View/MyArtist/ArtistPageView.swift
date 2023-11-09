//
//  ArtistPageView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 11/7/23.
//

import SwiftUI

struct ArtistPageView: View {
    //MARK: -1.PROPERTY
    @EnvironmentObject var service: Service
    @StateObject var viewModel: ArtistPageViewModel
    
    
    //MARK: -2.BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: UIScreen.getWidth(5)) {
                
                artistPageImage
                    .scrollDisabled(true)
                artistPageTitle
                
                artistPageFollowButton
                
                Spacer()
            }
        }
        .background(backgroundView())
        .ignoresSafeArea()
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear{
            viewModel.isfollowing = service.user.follow.contains(viewModel.artist.id)
        }
    }
}

//MARK: -4.EXTENSION
extension ArtistPageView {
    var artistPageImage: some View {
        AsyncImage(url: URL(string: viewModel.artist.artistImageURL)) { image in
            image.resizable().aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
        .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
        .overlay (
            HStack(spacing: UIScreen.getWidth(10)){
                if viewModel.artist.youtubeURL != "" {
                    Button {
                        UIApplication.shared.open(URL(string: (viewModel.artist.youtubeURL)!)!)
                    } label: { linkButton(name: YouTubeLogo).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5)) }
                }
                
                if viewModel.artist.instagramURL != "" {
                    Button {
                        UIApplication.shared.open(URL(string: (viewModel.artist.instagramURL)!)!)
                    } label: { linkButton(name: InstagramLogo).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5)) }
                }
                
                if viewModel.artist.soundcloudURL != "" {
                    Button {
                        UIApplication.shared.open(URL(string: (viewModel.artist.instagramURL)!)!)
                    } label: { linkButton(name: SoundCloudLogo).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5)) }
                }
            }
                .frame(height: UIScreen.getHeight(25))
                .padding(.init(top: 0, leading: 0, bottom: UIScreen.getWidth(20), trailing: UIScreen.getWidth(15)))
            ,alignment: .bottomTrailing )
    }
    
    var artistPageTitle: some View {
        return VStack{
            Text(viewModel.artist.artistName)
                .font(.custom40black())
                .shadow(color: .black.opacity(1),radius: UIScreen.getWidth(9))
            Text(viewModel.artist.artistInfo)
                .font(.custom13heavy())
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }.padding(.bottom, UIScreen.getHeight(20))
    }
    
    var artistPageFollowButton: some View {
        Button {
            if service.user.follow.contains(viewModel.artist.id) == false {
                service.follow(artistId: viewModel.artist.id)
            } else {
                service.unfollow(artistId: viewModel.artist.id)
            }
        } label: {
            Text(viewModel.isfollowing ? "Unfollow" : "Follow")
                .font(.custom21black())
                .padding(.init(top: UIScreen.getHeight(7), leading: UIScreen.getHeight(30), bottom: UIScreen.getHeight(7), trailing: UIScreen.getHeight(30)))
                .background{ Capsule().stroke(Color.white, lineWidth: UIScreen.getWidth(2)) }
                .modifier(dropShadow())
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }
    }
}