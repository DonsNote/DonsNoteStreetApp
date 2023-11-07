//
//  EditUserArtistAcountView.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 11/7/23.
//

import SwiftUI

struct EditUserArtistAcountView: View {
    //MARK: -1.PROPERTY
    @EnvironmentObject var service: Service
    @Environment(\.dismiss) var dismiss
    @State var showDeleteAlert: Bool = false
    @Binding var isartistDelete: Bool
    
    //MARK: -2.BODY
    var body: some View {
        ZStack(alignment: .topLeading) {
            backgroundView().ignoresSafeArea()
            VStack(alignment: .leading) {
                //탈퇴
                Button {
                    showDeleteAlert = true
                } label: {
                    Text("아티스트 계정 삭제")
                        .foregroundStyle(Color(appRed))
                        .font(.custom13bold())
                        .padding(UIScreen.getWidth(20))
                        .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                }
                Spacer()
            }.padding(.top, UIScreen.getHeight(100))
                .alert(isPresented: $showDeleteAlert) {
                    Alert(title: Text(""), message: Text("멤버들과 등록된 버스킹들이 모두 삭제됩니다. 삭제 하시겠습니까??"), primaryButton: .destructive(Text("Delete"), action: {
                        print("탈퇴 완료")
                        service.deleteUserArtist()
                        showDeleteAlert = false
                        isartistDelete = false
                        dismiss()
                    }), secondaryButton: .cancel(Text("Cancle")))
                }
        }
    }
}

//MARK: -3.PREVIEW
#Preview {
    EditUserArtistAcountView(isartistDelete: .constant(true))
}
