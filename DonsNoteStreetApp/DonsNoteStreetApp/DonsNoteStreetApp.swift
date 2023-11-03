//
//  DonsNoteStreetApp.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import SwiftUI
import AuthenticationServices

@main
struct DonsNoteStreetAppApp: App {
//MARK: - 1. PROPERTY
//    @StateObject var appleLogin = AppleLoginViewModel()
    @StateObject var service = Service()
    
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
