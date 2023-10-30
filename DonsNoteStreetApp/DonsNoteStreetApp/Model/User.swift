//
//  User.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import Foundation

struct User : Codable {
    
    var id : Int
    var userName : String
    var userInfo : String
    var userImageURL : String
    var userArtist : Artist?
    
    init(
        
        id : Int = 0,
        userName : String = "",
        userInfo : String = "",
        userImageURL : String = "",
        userArtist : Artist = Artist()
    
    ) {
        
        self.id = id
        self.userName = userName
        self.userInfo = userInfo
        self.userImageURL = userImageURL
        self.userArtist = userArtist
    }
}
