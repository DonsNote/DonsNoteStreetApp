//
//  EditBlockListView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 11/10/23.
//

import SwiftUI

struct EditBlockListView: View {
    
    //MARK: -1.PROPERTY
    @EnvironmentObject var service: Service
    @State var isEditMode: Bool = false
    @State var deleteAlert: Bool = false
    let columns = Array(
        repeating: GridItem(.flexible(), spacing: 0),
        count: 3
    )
    
    //MARK: -2.BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(service.blockList) { i in
                    NavigationLink {
                        ArtistPageView(viewModel: ArtistPageViewModel(artist: i))
                    } label: {
                        ProfileRectangle(image: i.artistImageURL, name: i.artistName)
                    }
                    .overlay(alignment: .topTrailing) {
                        if isEditMode {
                            Button {
                                //TODO: 팔로우리스트에서 지우기
                                deleteAlert = true
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.custom25bold())
                                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                                    .foregroundStyle(Color.appBlue)
                                    .padding(-UIScreen.getWidth(5))
                            }
                        }
                    } .scaleEffect(0.8)
                        .alert(isPresented: $deleteAlert) {
                            Alert(title: Text(""), message: Text("Do you want to unBlock?"), primaryButton: .destructive(Text("UnBlock"), action: {
                                service.unblock(artistId: i.id)
                            }), secondaryButton: .cancel(Text("Cancle")))
                        }
                }
            }.padding(.init(top: UIScreen.getWidth(10), leading: UIScreen.getWidth(10), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(10)))
        }.background(backgroundView().ignoresSafeArea()).navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isEditMode.toggle()
                    } label: {
                        toolbarButtonLabel(buttonLabel: isEditMode ? "Done" : "Edit")
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
    }
}

//MARK: -3.PREVIEW

#Preview {
    NavigationView {
        EditBlockListView().environmentObject(Service())
    }
}

//MARK: -4.EXTENSION

