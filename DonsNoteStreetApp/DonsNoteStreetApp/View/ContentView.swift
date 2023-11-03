//
//  ContentView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import SwiftUI

struct ContentView: View {
//MARK: - 1. PROPERTY
    
    @EnvironmentObject var service : Service
    
    var body: some View {
//MARK: - 2. BODY
        
        TabView(selection: .constant(2), content: {
            
            MyArtist()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("My Artist")
                }
                .tag(0)
            
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
                .tag(2)
        })
    }
}

//MARK: - 3. PREVIEW
#Preview {
    ContentView().environmentObject(Service())
}
