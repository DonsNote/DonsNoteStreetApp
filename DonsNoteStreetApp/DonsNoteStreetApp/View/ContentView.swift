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
    @State private var selection = 1
    
    //MARK: - 2. BODY
    var body: some View {
//        ZStack{
//            if service.user.userName == "" {
//                backgroundView()
//                ProgressView()
//            } else {
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
//                }
//            }
        }
        .onAppear {
            service.getUserProfile()
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
       
        .onChange(of: selection) {
            switch selection {
            case 0 :
                service.getMyArtist()
            case 1 :
                service.getNowBusking{}
            case 2 :
                service.getUserProfile()
                service.getBlockList()
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
