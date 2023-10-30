//
//  dropShadowModifier.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import SwiftUI

struct dropShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .white.opacity(0.1) ,radius: 3)
    }
}

