//
//  Alert.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/22/21.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Alert : Codable, Identifiable {

    @DocumentID var id: String?
    var userID: String
    var kindOfAlert: TypeOfThreat
    var timestamp: Int?
    var animal: KindOfAnimal
    var image: String?
    var city: String
    var address: String
    var description: String?
    var isActive: Bool
    
}

enum TypeOfThreat: String, Codable {
    case Rescue, Adoption, Wounded, Maltreatment, Desnutrition
}

enum KindOfAnimal: String,Codable {
    
    case dog, cat, bird , other
    
    var animal : String {
        switch self {
        case .dog:
            return "dog"
        case .cat:
            return "cat"
        case .bird:
            return "bird"
        case .other:
            return "other"
        }
    }
    
}

#if DEBUG
var user1 = User(username: "Michael",email: "mike@gmail.com")
var alertList = [
    Alert(id: "jsjdnakkw", userID: user1.username , kindOfAlert: .Rescue, animal: .dog, image: "helloImage", city: "Medellin", address: "Calle 13 # 43D - 79", description: "He is wounded and need to be heal", isActive: true),
//    Alert(user: user1.name , kindOfAlert: .Adoption, timestamp: 2, animal: .cat, images: "helloImage", location: "Medellin", description: "He need to be adopted", isActive: false),
//    Alert(user: user1.name , kindOfAlert: .Desnutrition, timestamp: 5, animal: .bird, images: "helloImage", location: "Medellin", description: "He need food", isActive: false),
//    Alert(user: user1.name, kindOfAlert: .Maltreatment, timestamp: 7, animal: .other, images: "helloImage", location: "Medellin", description: "He need food", isActive: false)
]
#endif
