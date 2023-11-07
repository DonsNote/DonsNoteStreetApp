//
//  UserPageViewModel.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//
import SwiftUI
import PhotosUI

class UserPageViewModel: ObservableObject {
    
    @Published var isEditMode: Bool = false
  
    @Published var popImagePicker: Bool = false
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedPhotoData: Data?
    @Published var copppedImageData: Data?
    @Published var croppedImage: UIImage?
    
    @Published var isLoading: Bool = false
    
    @Published var EditUsername: String = "User"
    @Published var EditUserInfo: String = "Simple Imforamtion of This User"
    
    @Published var isEditName: Bool = false
    @Published var isEditInfo: Bool = false
      
    @Published var nameSaveOKModal: Bool = false
    @Published var infoSaveOKModal: Bool = false

}
