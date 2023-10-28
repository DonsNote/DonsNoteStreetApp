//
//  Member.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import Foundation

struct Member : Codable {
    
    var id : Int?
    var memberName : String?
    var memberInfo : String?
    var memberImage : String?
    
    init (
        
        id : Int = 0,
        memberName : String = "",
        memberInfo : String = "",
        memberImage : String = ""
        
    ) {
        
        self.id = id
        self.memberName = memberName
        self.memberInfo = memberInfo
        self.memberImage = memberImage
    }
}
