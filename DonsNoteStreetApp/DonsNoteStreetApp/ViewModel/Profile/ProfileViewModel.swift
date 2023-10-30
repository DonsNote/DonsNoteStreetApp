//
//  ProfileViewModel.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var switchNotiToggle: Bool = false
    @Published var isArtistAccount: Bool = true
    @Published var popArtistProfile: Bool = false
    
}
