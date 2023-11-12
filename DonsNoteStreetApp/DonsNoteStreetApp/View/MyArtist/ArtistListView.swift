//
//  ArtistListView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 11/7/23.
//

import SwiftUI

struct ArtistListView: View {
//MARK: -1.PROPERTY
    
    @EnvironmentObject var service: Service
    let columns = Array(
        repeating: GridItem(.flexible(), spacing: 0),
        count: 3
    )
    
//MARK: -2.BODY
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(service.allArtist.shuffled()) { i in
                    NavigationLink {
                        ArtistPageView(viewModel: ArtistPageViewModel(artist: i))
                    } label: {
                        ProfileRectangle(image: i.artistImageURL, name: i.artistName).scaleEffect(0.9)
                    }
                }
            }
            .padding(.init(top: UIScreen.getWidth(10), leading: UIScreen.getWidth(10), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(10)))
        }
        .background(backgroundView().ignoresSafeArea()).navigationTitle("")
        .onAppear {
            service.getAllArtist()
        }
    }
}

//MARK: -3.PREVIEW

#Preview {
    NavigationView {
        ArtistListView().environmentObject(Service())
    }
}
