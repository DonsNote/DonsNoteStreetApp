//
//  UserPageView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import SwiftUI
import PhotosUI

struct UserPageView: View {
    
//MARK: - 1.PROPERTY
    
    @EnvironmentObject var service: Service
    @StateObject var viewModel = UserPageViewModel()
    
//MARK: - 2.BODY
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: UIScreen.getWidth(5)) {
                    if viewModel.croppedImage != nil { pickedImage }
                    else { userPageImage }
                    userPageTitle
                    Spacer()
                }
            }.blur(radius: viewModel.isEditName || viewModel.isEditInfo ? 15 : 0)
            if viewModel.isEditName || viewModel.isEditInfo {
                Color.black.opacity(0.1)
                    .onTapGesture {
                        viewModel.isEditName = false
                        viewModel.isEditInfo = false
                    }
            }
            if viewModel.isEditName {
                editNameSheet
            }
            if viewModel.isEditInfo {
                editInfoSheet
            }
        }
        .background(backgroundView())
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { firstToolbarItem.opacity(viewModel.isEditName || viewModel.isEditInfo ? 0 : 1) }
            ToolbarItem(placement: .topBarTrailing) { secondToolbarItem.opacity(viewModel.isEditName || viewModel.isEditInfo ? 0 : 1) }
        }
        .cropImagePicker(show: $viewModel.popImagePicker, croppedImage: $viewModel.croppedImage, isLoding: $viewModel.isLoading)
        .onAppear{
            
            viewModel.EditUsername = service.user.userName
            viewModel.EditUserInfo = service.user.userInfo
        }
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
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationTitle("")
    }
}

//MARK: -3.EXTENSION

extension UserPageView {
    var userPageImage: some View {
        AsyncImage(url: URL(string: service.user.userImageURL)) { image in
            image.resizable().aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
        .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
        .overlay(alignment: .bottom) {
            if viewModel.isEditMode {
                Button{
                    viewModel.popImagePicker = true
                } label: {
                    Image(systemName: "camera.circle.fill")
                        .font(.custom40bold())
                        .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                }
            }
        }
    }
    
    var pickedImage: some View {
        Image(uiImage: viewModel.croppedImage!)
            .resizable()
            .scaledToFit()
            .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
            .overlay(alignment: .bottom) {
                if viewModel.isEditMode {
                    PhotosPicker(
                        selection: $viewModel.selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Image(systemName: "camera.circle.fill")
                                .font(.custom40bold())
                                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                        }
                }
            }
    }
    
    var userPageTitle: some View {
        return VStack{
            ZStack {
                Text(service.user.userName)
                    .font(.custom40black())
                if viewModel.isEditMode {
                    HStack {
                        Spacer()
                        Button {
                            viewModel.isEditName = true
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.custom20semibold())
                                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                                .padding(.horizontal)
                        }
                    }
                }
            }
            
            ZStack {
                Text(service.user.userInfo)
                    .font(.custom13heavy())
                if viewModel.isEditMode {
                    HStack {
                        Spacer()
                        Button { viewModel.isEditInfo = true } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.custom20semibold())
                                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }.padding(.bottom, UIScreen.getHeight(20))
    }
    
    var firstToolbarItem: some View {
        if viewModel.isEditMode {
            return AnyView(Button {
                viewModel.isEditMode = false
                viewModel.croppedImage = nil
                service.getUserProfile()
            } label: {
                toolbarButtonLabel(buttonLabel: "Cancle").shadow(color: .black.opacity(0.5),radius: UIScreen.getWidth(8))
            })
        } else {
            return AnyView(EmptyView())
        }
    }
    
    var secondToolbarItem: some View {
        if viewModel.isEditMode {
            return AnyView(Button{
                service.croppedImage = viewModel.croppedImage
                service.user.userName = viewModel.EditUsername
                service.user.userInfo = viewModel.EditUserInfo
                
                service.patchUserProfile()
                viewModel.isEditMode = false
            } label: {
                toolbarButtonLabel(buttonLabel: "Save").shadow(color: .black.opacity(0.5),radius: UIScreen.getWidth(8))
            })
        } else {
            return AnyView(Button{
                viewModel.isEditMode = true
            } label: {
                toolbarButtonLabel(buttonLabel: "Edit").shadow(color: .black.opacity(0.5),radius: UIScreen.getWidth(8))
            })
        }
    }
    
    
    var editNameSheet: some View {
        VStack(alignment: .leading, spacing: UIScreen.getWidth(10)) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.getWidth(20))
                    .padding(.leading, UIScreen.getWidth(3))
                Text("User Name").font(.custom14semibold())
            }
            TextField(service.user.userName, text: $viewModel.EditUsername)
                .font(.custom10semibold())
                .padding(UIScreen.getWidth(12))
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            
            Button {
                service.user.userName = viewModel.EditUsername
                viewModel.nameSaveOKModal = true
                withAnimation(.smooth(duration: 0.5)) {
                    viewModel.nameSaveOKModal = false
                    viewModel.isEditName = false
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Save")
                    Spacer()
                }
                .font(.custom14semibold())
                .padding(UIScreen.getWidth(14))
                .background(LinearGradient(colors: [.appSky ,.appIndigo1, .appIndigo2], startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(6)
            }
        }
        .padding(.horizontal, UIScreen.getWidth(10))
        .presentationDetents([.height(UIScreen.getHeight(150))])
        .presentationDragIndicator(.visible)
    }
    
    var editInfoSheet: some View {
        VStack(alignment: .leading, spacing: UIScreen.getWidth(10)) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.getWidth(20))
                    .padding(.leading, UIScreen.getWidth(3))
                Text("User Info").font(.custom14semibold())
            }
            TextField(service.user.userInfo, text: $viewModel.EditUserInfo)
                .font(.custom10semibold())
                .padding(UIScreen.getWidth(12))
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            
            Button {
                service.user.userInfo = viewModel.EditUserInfo
                viewModel.infoSaveOKModal = true
                withAnimation(.smooth(duration: 0.5)) {
                    viewModel.infoSaveOKModal = false
                    viewModel.isEditInfo = false
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Save")
                    Spacer()
                }
                .font(.custom14semibold())
                .padding(UIScreen.getWidth(14))
                .background(LinearGradient(colors: [.appSky ,.appIndigo1, .appIndigo2], startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(6)
            }
        }
        .padding(.horizontal, UIScreen.getWidth(10))
        .presentationDetents([.height(UIScreen.getHeight(150))])
        .presentationDragIndicator(.visible)
    }
}

//MARK: -4.PREVIEW

#Preview {
    NavigationView {
        UserPageView().environmentObject(Service())
    }
}
