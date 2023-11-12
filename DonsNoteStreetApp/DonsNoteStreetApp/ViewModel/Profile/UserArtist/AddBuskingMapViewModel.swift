//
//  AddBuskingMapViewModel.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 11/10/23.
//

import SwiftUI
import CoreLocation
import MapKit

class AddBuskingMapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var markerAddressString: String = "address"
    @Published var startTime = Date()
    @Published var endTime = Date()
    @Published var query: String = ""
    @Published var searchResults: [MKMapItem] = [] // MapKit 검색 결과
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    
    @Published var locationManager: CLLocationManager
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }

    func searchPlaces(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            self.searchResults = response.mapItems
        }
    }

    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: startTime)
    }
    func formatStartTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분"
        return formatter.string(from: startTime)
    }
    func formatEndTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분"
        return formatter.string(from: endTime)
    }
}
