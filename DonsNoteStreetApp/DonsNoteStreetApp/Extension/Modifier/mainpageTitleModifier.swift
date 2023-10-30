//
//  mainpageTitleModifier.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import SwiftUI

struct mainpageTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom21black())
            .padding(.horizontal)
            .padding(.vertical, 3)
            .background{
                Capsule().stroke(Color.white, lineWidth: 2)}
            .shadow(color: .white.opacity(0.15) ,radius: 10, x: -5,y: -5)
            .shadow(color: .black.opacity(0.35) ,radius: 10, x: 5,y: 5)
    }
}

