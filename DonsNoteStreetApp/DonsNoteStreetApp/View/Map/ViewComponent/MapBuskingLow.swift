//
//  MapBuskingLow.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 11/14/23.
//

import SwiftUI
import CoreLocation

struct MapBuskingLow: View {
    
    //MARK: -1.PROPERTY
    @EnvironmentObject var service : Service
    @State private var addressString : String = ""
    var artist : Artist
    var busking : Busking
    @State var isLoading: Bool = false
    
    //MARK: -2.BODY
    var body: some View {
        ZStack {
            HStack(spacing: UIScreen.getWidth(10)) {
                CircleBlur(image: busking.artistImageURL, width: 120, strokeColor: Color(appIndigo2), shadowColor: Color(appIndigo2))
                    .padding(.horizontal, UIScreen.getWidth(10))
                
                VStack(alignment: .leading,spacing: UIScreen.getWidth(4)) {
                    HStack {
                        Text(service.targetArtist.artistName)
                            .font(.custom22black())
                            .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                            .padding(.bottom, UIScreen.getHeight(4))
                        Spacer()
                        NavigationLink {
                            ArtistPageView(viewModel: ArtistPageViewModel(artist: artist))
                        } label: {
                            Image(systemName: "chevron.forward.circle.fill").font(.custom25bold())
                        }
                    }
                    HStack(spacing: UIScreen.getWidth(8)) {
                        Image(systemName: "bubble.left").font(.custom14semibold())
                        Text(busking.buskingInfo) .font(.custom13bold())
                            .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                    }
                    HStack(spacing: UIScreen.getWidth(8)) {
                        Image(systemName: "clock").font(.custom14semibold())
                        Text("\(formatStartTime()) ~ \(formatEndTime())").font(.custom13bold())
                            .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                    }
                    HStack(spacing: UIScreen.getWidth(8)) {
                        Image(systemName: "signpost.right").font(.custom14semibold())
                        Text("\(addressString)").font(.custom13bold())
                            .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                    }
                }.frame(height: UIScreen.getHeight(130))
                Spacer()
            } 
            .blur(radius: isLoading ? 32 : 0)
            if isLoading {
                ProgressView()
            }
        }
        .background(backgroundView())
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .frame(height: UIScreen.getHeight(130))
        .overlay {
            RoundedRectangle(cornerRadius: 30)
                .stroke(lineWidth: UIScreen.getWidth(1))
                .blur(radius: 2)
                .foregroundColor(Color.white.opacity(0.3))
                .padding(1)
        }
        .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.3), radius: UIScreen.getWidth(4))
        .onAppear {
            isLoading = true
            service.getTargetArtist(artistId: busking.artistId) {
                isLoading = false
            }
            reverseGeo(busking: busking)
        }
    }
}

//MARK: - 3.EXTENSION
extension MapBuskingLow {
    func reverseGeo(busking: Busking) {
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
}
