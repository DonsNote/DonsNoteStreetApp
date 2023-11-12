//
//  UserArtistPageViewModel.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 11/5/23.
//

import SwiftUI
import PhotosUI

class AddUserArtistViewModel: ObservableObject {
    
    @Published var isEditMode: Bool = true
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedPhotoData: Data?
    @Published var popImagePicker: Bool = false
    @Published var copppedImageData: Data?
    @Published var croppedImage: UIImage?
    @Published var isLoading: Bool = false
    
    @Published var artistName: String = ""
    @Published var artistInfo : String = ""
    @Published var genres: String = ""
    
    @Published var youtubeURL: String = ""
    @Published var instagramURL: String = ""
    @Published var soundcloudURL: String = ""
    
}

