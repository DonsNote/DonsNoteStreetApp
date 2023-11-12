//
//  ArtistInfoModalView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 11/12/23.
//

import SwiftUI

struct ArtistInfoModalView: View {
    
    //MARK: -1.PROPERTY
    @ObservedObject var viewModel: ArtistInfoModalViewModel
    
    //MARK: -2.BODY
    var body: some View {
        VStack(spacing: UIScreen.getHeight(15)) {
            Spacer()
            artistInfoToolbar
            artistInfoImage
            buskingTime
            NavigationLink {
                ArtistPageView(viewModel: ArtistPageViewModel(artist: viewModel.artist))
            } label: { sheetBoxText(text: "더보기").shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5)) }
        }.background(backgroundView())
    }
}

//MARK: -3. EXTENSION
extension ArtistInfoModalView {
    var likeButton: some View {
        Button {
            viewModel.toggleLike()
        } label: {
            Image(systemName: viewModel.isClickedLike ? "heart.fill" : "heart")
                .foregroundStyle(viewModel.isClickedLike ? Color(appRed) : Color.white)
                .font(.custom22light())
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }
    }
    var artistInfoToolbar: some View {
        HStack{
            Text(viewModel.artist.artistName)
                .font(.custom25bold())
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            Spacer()
            likeButton
        }.padding(.init(top: UIScreen.getWidth(10), leading: UIScreen.getWidth(15), bottom: UIScreen.getWidth(0), trailing: UIScreen.getWidth(15)))
    }
    var artistInfoImage: some View {
        CircleBlur(image: viewModel.artist.artistImageURL, width: UIScreen.getWidth(120),strokeColor: Color(appIndigo2), shadowColor: Color(appIndigo2))
    }
    
    var buskingTime: some View {
        Text("\(viewModel.formatStartTime()) ~ \(viewModel.formatEndTime())")
            .font(.custom13heavy())
            .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            .padding(.init(top: UIScreen.getWidth(10), leading: UIScreen.getWidth(30), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(30)))
            .overlay(alignment: .leading) {
                Image(systemName: "clock")
                    .font(.custom14semibold())
            }
    }
}