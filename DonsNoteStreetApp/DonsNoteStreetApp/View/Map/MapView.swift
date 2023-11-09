//
//  MapView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject var service : Service
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: service.nowBusking, annotationContent: { item in
            MapAnnotation(coordinate: item.location) {
                MapAnnotationView(busking: item)
            }
        })
        .onAppear {
            viewModel.requestAuthorization()
        }
    }
}

//MARK: - PREVIEW
#Preview {
    MapView().environmentObject(Service())
}
