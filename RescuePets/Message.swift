//
//  Message.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/22/21.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Message: Codable, Identifiable {

    var id: String = UUID().uuidString
    var from: User
    var to: User
    var message: String
    var timestamp: Int
    
}


//#if DEBUG
//var user2 = User(username: "Manuel", email: "manuel@gmail.com")
//var messages = [
//    Message(from: user1, to: user2, message: "hello", timestamp: 1)
//]
//#endif
