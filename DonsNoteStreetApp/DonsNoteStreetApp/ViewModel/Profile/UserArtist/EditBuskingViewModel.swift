//
//  EditBuskingViewModel.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 11/14/23.
//

import Foundation

class EditBuskingViewModel: ObservableObject {
    @Published var popBuskingModal: Bool = false
    @Published var selectedBusking: Busking = Busking()
    @Published var selectedArtist: Artist = Artist()
//    @Published var following: [Artist] = []
//    @Published var nowBusking: [Busking] = []
    @Published var isEditMode: Bool = false
    @Published var deleteAlert: Bool = false
}
