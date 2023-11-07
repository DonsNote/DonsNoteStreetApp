//
//  ArtistPageViewModel.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 11/7/23.
//

import SwiftUI

class ArtistPageViewModel: ObservableObject {
    @Published var artist: Artist
    @Published var isfollowing: Bool = false
    init(artist: Artist) {
        self.artist = artist
    }
}
