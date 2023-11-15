//
//  AddUserArtistView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import SwiftUI
import PhotosUI

struct AddUserArtistView: View {
    
    //MARK: - 1.PROPERTY
    
    @EnvironmentObject var service : Service
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = AddUserArtistViewModel()
    @State var isLoading: Bool = false
    
    //MARK: - 2.BODY
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: UIScreen.getWidth(5)) {
                    imagePickerView
                    Spacer()
                    nameTextField
                    infoTextField
                    Spacer()
                    customDivider()
                    Spacer()
                    youtubeTextField
                    instagramTextField
                    soundcloudTextField
                    Spacer()
                    registerButton
                    Spacer()
                }
            }
            if isLoading {
                ProgressView()
            }
        }
        .background(backgroundView())
        .hideKeyboardWhenTappedAround()
        .ignoresSafeArea()
        .cropImagePicker(show: $viewModel.popImagePicker, croppedImage: $viewModel.croppedImage, isLoding: $viewModel.isLoading)
        .onChange(of: viewModel.selectedItem) {
            Task {
                if let data = try? await viewModel.selectedItem?.loadTransferable(type: Data.self) {
                    viewModel.selectedPhotoData = data
                }
            }
        }
        .onChange(of: viewModel.selectedPhotoData) {
            if let data = viewModel.selectedPhotoData, let uiImage = UIImage(data: data) {
                viewModel.copppedImageData = data
                viewModel.croppedImage = uiImage
                viewModel.popImagePicker = false
            }
        }
    }
}
//MARK: - 3 .EXTENSION
extension AddUserArtistView {
    
    var imagePickerView: some View {
        Image(uiImage: viewModel.croppedImage ?? UIImage(named: "Default")!)
            .resizable()
            .scaledToFit()
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
            .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
            .overlay(alignment: .bottom) {
                Button{
                    viewModel.popImagePicker = true
                } label: {
                    Image(systemName: "camera.circle.fill")
                        .font(.custom40bold())
                        .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                }
            }
            .overlay(alignment: .topLeading) {
                Button {
                    viewModel.copppedImageData = nil
                    viewModel.croppedImage = nil
                    viewModel.popImagePicker = false
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.custom20bold())
                        .padding(.init(top: UIScreen.getWidth(45), leading: UIScreen.getWidth(25), bottom: 0, trailing: 0))
                }
            }
    }
    
    var imagePicker: some View {
        Button {
            viewModel.popImagePicker = true
        } label: {
            if viewModel.croppedImage != nil {
                Image(uiImage: viewModel.croppedImage!)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: UIScreen.getHeight(140))
                    .mask(RadialGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black,Color.black,Color.black,Color.black, Color.clear]), center: .center,startRadius: 0, endRadius: UIScreen.getHeight(70)))
                    .shadow(color: .white.opacity(0.4),radius: UIScreen.getHeight(5))
                    .overlay {
                        Circle()
                            .stroke(lineWidth: UIScreen.getHeight(2))
                            .blur(radius: UIScreen.getHeight(3))
                            .foregroundColor(Color(appIndigo).opacity(0.6))
                            .padding(0)
                    }
            } else {
                Circle()
                    .stroke(lineWidth: UIScreen.getHeight(3))
                    .frame(width: UIScreen.getHeight(140))
                    .overlay {
                        Image(systemName: "photo.on.rectangle.angled")
                            .foregroundColor(.white)
                            .font(.custom34regular())
                    }
            }
        }
    }
    var nameTextField: some View {
        VStack(alignment: .leading,spacing: UIScreen.getWidth(4)) {
            Text("Nickname") .font(.custom12semibold()).padding(.leading, UIScreen.getWidth(4))
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("닉네임을 입력하세요", text: $viewModel.artistName)
                    .font(.custom12semibold())
                    .padding(UIScreen.getWidth(11))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            }
        }.padding(UIScreen.getWidth(5))
    }
    
    var infoTextField: some View {
        VStack(alignment: .leading,spacing: UIScreen.getWidth(4)) {
            Text("Your Info") .font(.custom12semibold()).padding(.leading, UIScreen.getWidth(4))
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("Information을 입력하세요", text: $viewModel.artistInfo)
                    .font(.custom12semibold())
                    .padding(UIScreen.getWidth(11))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            }
        }.padding(UIScreen.getWidth(5))
    }
    
    var youtubeTextField: some View {
        VStack(alignment: .leading,spacing: UIScreen.getWidth(4)) {
            HStack {
                linkButton(name: YouTubeLogo).frame(width: UIScreen.getWidth(22)).padding(.leading, UIScreen.getWidth(4))
                Text("Youtube") .font(.custom12semibold())
            }
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("Youtube 계정을 입력하세요", text: $viewModel.youtubeURL)
                    .font(.custom12semibold())
                    .padding(UIScreen.getWidth(11))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            }
        }.padding(UIScreen.getWidth(5))
    }
    
    var instagramTextField: some View {
        VStack(alignment: .leading,spacing: UIScreen.getWidth(4)) {
            HStack {
                linkButton(name:InstagramLogo).frame(width: UIScreen.getWidth(22)).padding(.leading, UIScreen.getWidth(4))
                Text("Instagram") .font(.custom12semibold())
            }
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("Instagram 계정을 입력하세요", text: $viewModel.instagramURL)
                    .font(.custom12semibold())
                    .padding(UIScreen.getWidth(11))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            }
        }.padding(UIScreen.getWidth(5))
    }
    
    var soundcloudTextField: some View {
        VStack(alignment: .leading,spacing: UIScreen.getWidth(4)) {
            HStack {
                linkButton(name:SoundCloudLogo).frame(width: UIScreen.getWidth(22)).padding(.leading, UIScreen.getWidth(4))
                Text("SoundCloud") .font(.custom12semibold())
            }
            HStack(spacing: UIScreen.getWidth(8)){
                TextField("Sound Cloud 계정을 입력하세요", text: $viewModel.soundcloudURL)
                    .font(.custom12semibold())
                    .padding(UIScreen.getWidth(11))
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
            }
        }.padding(UIScreen.getWidth(5))
    }
    
    var registerButton: some View {
        Button {
            isLoading = true
            service.userArtistCroppedImage = viewModel.croppedImage
            service.userArtist.artistName = viewModel.artistName
            service.userArtist.genres = viewModel.genres
            service.userArtist.artistInfo = viewModel.artistInfo
            service.userArtist.youtubeURL = viewModel.youtubeURL
            service.userArtist.instagramURL = viewModel.instagramURL
            service.userArtist.soundcloudURL = viewModel.soundcloudURL
            
            service.postUserArtist()
            dismiss()
        } label: {
            HStack{
                Spacer()
                Text("Register").font(.custom13bold())
                Spacer()
            }
            .padding(UIScreen.getWidth(15))
            .background(viewModel.artistName.isEmpty || viewModel.artistInfo.isEmpty ? Color.gray.opacity(0.3) : Color(appIndigo))
            .cornerRadius(6)
            .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
        }.disabled(viewModel.artistName.isEmpty || viewModel.artistInfo.isEmpty).padding(UIScreen.getWidth(5))
    }
}
