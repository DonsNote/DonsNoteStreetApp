//
//  MyArtistViewModel.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 11/7/23.
//

import Foundation

class MyArtistViewModel: ObservableObject {
    @Published var popBuskingModal: Bool = false
    @Published var selectedBusking: Busking = Busking()
    @Published var selectedArtist: Artist = Artist()
    @Published var following: [Artist] = []
    @Published var nowBusking: [Busking] = []

}
