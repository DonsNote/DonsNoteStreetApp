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
    @State private var selection = 2
    
    var body: some View {
        //MARK: - 2. BODY
        
        TabView(selection: $selection) {
            MyArtistView()
                .tabItem {
                    Image(systemName: "music.note.list")
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
        }
        .onChange(of: selection) { newSelection in
            switch newSelection {
            case 0 :
                service.getUserProfile()
            case 1 :
                service.getUserProfile()
            case 2 :
                service.getUserProfile()
            default :
                break
            }
        }
    }
}

//MARK: - 3. PREVIEW
#Preview {
    ContentView().environmentObject(Service())
}
