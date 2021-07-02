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


#if DEBUG
var user2 = User(name: "Manuel", kindOfUser: .casual, email: "manuel@gmail.com", badges: [], location: "Medellin")
var messages = [
    Message(from: user1, to: user2, message: "hi how are you today", timestamp: 1),
    Message(from: user2, to: user1, message: "Everything great thanks for asking and you?", timestamp: 2),
    Message(from: user1, to: user2, message: "I´m ok too", timestamp: 3),
    Message(from: user1, to: user2, message: "well, shall we", timestamp: 5),
]
#endif
