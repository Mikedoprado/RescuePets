//
//  User.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/22/21.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User : Codable, Identifiable{

    @DocumentID var id: String?
    var name: String
    var kindOfUser: TypeOfUser?
    var email: String
    var badges: [Badges]?
    var location: String?
}

struct Badges: Codable {
    var achievement: String
    var badge : String
}

enum TypeOfUser : String, Codable {
    case animalist, foundation, casual
}