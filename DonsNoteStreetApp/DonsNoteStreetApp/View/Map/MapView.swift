//
//  MapView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import SwiftUI
import GoogleMaps

struct MapView: View {
    
    //MARK: -1.PROPERTY
    @EnvironmentObject var service: Service
    @StateObject var viewModel = MapViewModel()
    
    //MARK: -2.BODY
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom){
                if viewModel.mapViewOn {
                    GoogleMapView(viewModel: viewModel)
                        .ignoresSafeArea(.all, edges: .top)
                    
                        .overlay(alignment: .top) {
                            MapViewSearchBar(viewModel: viewModel)
                                .padding(UIScreen.getWidth(4))
                        }
                } else {
                    backgroundView()
                        .overlay{
                            ProgressView()
                        }
                }
                if viewModel.popModal {
                    MapBuskingLow(artist: service.targetArtist, busking: viewModel.selectedBusking ?? Busking())
                        .padding(.init(top: UIScreen.getHeight(0), leading: UIScreen.getWidth(4), bottom: UIScreen.getHeight(12), trailing: UIScreen.getWidth(4)))
                }
            }
            .onTapGesture {
                viewModel.popModal = false
            }
            .background(backgroundView())
            .ignoresSafeArea(.keyboard)
            .navigationTitle("")
        }
        .onAppear {
            service.getNowBusking{
                    viewModel.mapViewOn = true
            }
        }
        .onDisappear {
            viewModel.popModal = false
            viewModel.mapViewOn = false
        }
    }
}


//MARK: - 3.PREVIEW
#Preview {
    MapView()
}
