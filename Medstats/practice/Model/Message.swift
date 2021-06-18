//
//  Message.swift
//  practice
//
//  Created by 陳其宏 on 2021/6/17.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Message : Identifiable,Codable {
    
    @DocumentID var id : String?
    var msg : String
    var date : Timestamp
    
    enum CodingKeys : String,CodingKey {
        case id
        case msg = "message"
        case date
    }

    
}
