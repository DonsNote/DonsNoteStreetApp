//
//  BackgroundView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import SwiftUI

struct backgroundView: View {
    var body: some View {
        ZStack {
            backgroundStill
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}
#Preview {
    backgroundView()
}
