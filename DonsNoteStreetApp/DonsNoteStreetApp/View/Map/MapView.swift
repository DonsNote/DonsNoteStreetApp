//
//  MapView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import SwiftUI
import MapKit

struct MapView: View {
//MARK: -1.PROPERTY
    
    @EnvironmentObject var service : Service
    @StateObject private var viewModel = MapViewModel()

//MARK: -2.BODY
    
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

//MARK: -3.PREVIEW
#Preview {
    MapView().environmentObject(Service())
}
