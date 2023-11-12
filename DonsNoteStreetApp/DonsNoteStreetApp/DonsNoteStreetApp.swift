//
//  DonsNoteStreetApp.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import SwiftUI
import GoogleMaps
import GooglePlaces
import AuthenticationServices

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}

@main
struct DonsNoteStreetAppApp: App {
//MARK: - 1. PROPERTY
    
    @StateObject var service = Service()
    
    let APIKey = "AIzaSyDF3d8OqWRipyjxQh7C2HF6KHn-C3YhSt8"
    
    init() {
        GMSServices.provideAPIKey(APIKey)
        GMSPlacesClient.provideAPIKey(APIKey)
    }
    
//MARK: - 2. BODY
    
    var body: some Scene {
        WindowGroup {
            if service.isLogin {
                ContentView().environmentObject(service)
            } else {
                AppleLoginView().environmentObject(service)
            }
        }
    }
}
