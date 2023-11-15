//
//  EditBuskingView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 11/7/23.
//

import SwiftUI

struct EditBuskingView: View {
    
    //MARK: -1.PROPERTY
    @EnvironmentObject var service: Service
    @StateObject var viewModel = EditBuskingViewModel()
    
    
    //MARK: -2.BODY
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: UIScreen.getWidth(15)) {
                HStack {
                    roundedBoxText(text: "My Busking List")
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                    Spacer()
                    
                }.padding(UIScreen.getWidth(20)).background(.clear)
                if service.myBusking.isEmpty {
                    HStack(alignment: .center, spacing: UIScreen.getWidth(8)) {
                        Spacer()
                        Image(systemName: "exclamationmark.circle.fill").font(.custom20semibold())
                        Text("지금은 등록한 공연이 없어요!")
                            .font(.custom13bold())
                            .fontWidth(.expanded)
                        Spacer()
                    }.shadow(color: .black.opacity(0.2),radius: UIScreen.getHeight(5))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .frame(height: UIScreen.getHeight(160))
                        .overlay {
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(lineWidth: UIScreen.getWidth(1))
                                .blur(radius: 2)
                                .foregroundColor(Color.white.opacity(0.1))
                                .padding(0)
                        }
                } else {
                 
                        VStack(spacing: UIScreen.getWidth(20)) {
                            ForEach(service.myBusking, id: \.id) { busking in
                                BuskingListRow(busking: busking)
                                    .onTapGesture {
                                        viewModel.selectedBusking = busking
                                        viewModel.popBuskingModal = true
                                    }
                                    .sheet(isPresented: $viewModel.popBuskingModal, onDismiss: {viewModel.popBuskingModal = false}) {
                                        MapBuskingModalView(viewModel: MapBuskingModalViewModel(busking: viewModel.selectedBusking))
                                            .presentationDetents([.medium])
                                            .presentationDragIndicator(.visible)
                                    }
                                    .overlay(alignment: .topTrailing) {
                                        if viewModel.isEditMode {
                                            Button {
                                                viewModel.deleteAlert = true
                                            } label: {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.custom25bold())
                                                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                                                    .foregroundStyle(Color.appBlue)
                                                    .padding(UIScreen.getWidth(5))
                                            }
                                        }
                                    }
                                    .alert(isPresented: $viewModel.deleteAlert) {
                                        Alert(title: Text(""), message: Text("Do you want to delete this busking?"), primaryButton: .destructive(Text("Delete"), action: {
                                            service.deleteBusking(buskingId: busking.id)
                                        }), secondaryButton: .cancel(Text("Cancle")))
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
        
        .padding(.init(top: UIScreen.getHeight(80), leading: UIScreen.getWidth(5), bottom: 0, trailing:  UIScreen.getWidth(5)))
        .navigationTitle("")
        .background(backgroundView())
        .ignoresSafeArea(.all)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.isEditMode.toggle()
                } label: {
                    toolbarButtonLabel(buttonLabel: viewModel.isEditMode ? "Done" : "Edit")
                }
            }
        }
        .onAppear{
            service.getMyBusking()
        }
    }
}

