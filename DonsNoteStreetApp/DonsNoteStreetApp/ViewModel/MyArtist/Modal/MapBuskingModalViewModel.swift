//
//  MapBuskingModalViewModel.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 11/8/23.
//

import Foundation
import CoreLocation

class MapBuskingModalViewModel: ObservableObject {
    @Published var isClickedLike: Bool = false
    @Published var busking: Busking
    @Published var addressString: String = ""

    init(busking: Busking) {
        self.busking = busking
        reverseGeo(busking: busking)
    }

    func toggleLike() {
        isClickedLike.toggle()
    }
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: busking.startTime)
    }
    func formatStartTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분"
        return formatter.string(from: busking.startTime)
    }
    func formatEndTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "h시 mm분"
        return formatter.string(from: busking.endTime)
    }

    private func reverseGeo(busking: Busking) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: busking.latitude, longitude: busking.longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                let district = placemark.locality ?? ""
                let street = placemark.thoroughfare ?? ""
                let buildingNumber = placemark.subThoroughfare ?? ""
                self.addressString = "\(district) \(street) \(buildingNumber) "
            }
        }
    }
}
