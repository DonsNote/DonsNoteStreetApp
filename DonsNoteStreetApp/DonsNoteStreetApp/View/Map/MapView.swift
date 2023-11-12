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
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var mapViewOn: Bool = false
    
    
    //MARK: -2.BODY
    var body: some View {
        NavigationView {
            ZStack(alignment: .top){
                if mapViewOn {
                    GoogleMapView(viewModel: viewModel)
                        .ignoresSafeArea(.all, edges: .top)
                        .overlay(alignment: .top) {
                            MapViewSearchBar(viewModel: viewModel)
                                .padding(UIScreen.getWidth(4))
                        }
                } else {
                    backgroundView()
                        .onAppear {
                            service.getNowBusking()
                        }
                }
            }
            .background(backgroundView())
            .ignoresSafeArea(.keyboard)
            .sheet(isPresented: $viewModel.popModal, onDismiss: {viewModel.popModal = false}) {
                ArtistInfoModalView(viewModel: ArtistInfoModalViewModel(artist: viewModel.selectedArtist!, buskingStartTime: viewModel.buskingStartTime, buskingEndTime: viewModel.buskingEndTime))
                    .presentationDetents([.height(UIScreen.getHeight(380))])
                    .presentationDragIndicator(.visible)
            }
        }
        .onDisappear {
            mapViewOn = false
        }
    }
}


//MARK: - 3.PREVIEW
#Preview {
    MapView().environmentObject(Service())
}
