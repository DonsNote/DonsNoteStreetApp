//
//  AddBuskingMapView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 11/7/23.
//

import SwiftUI

import SwiftUI
import MapKit

struct AddBuskingMapView: UIViewRepresentable {

//MARK: -1.PROPERTY
    @EnvironmentObject var service : Service
    @ObservedObject var viewModel : AddBuskingMapViewModel

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        if let location = viewModel.locationManager.location {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
        }

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let coordinate = viewModel.selectedCoordinate {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            uiView.setRegion(region, animated: true)
            viewModel.selectedCoordinate = nil
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: AddBuskingMapView

        init(_ parent: AddBuskingMapView) {
            self.parent = parent
        }

        // Add MKMapViewDelegate methods here as needed
    }
}

#Preview {
    AddBuskingMapView(viewModel: AddBuskingMapViewModel()).environmentObject(Service())
}

