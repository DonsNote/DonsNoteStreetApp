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
    @StateObject var service = Service()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(service)
        }
    }
}
