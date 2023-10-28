//
//  ContentView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        TabView {
            MyArtist()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("My Artist")
                }
            
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    ContentView()
}
