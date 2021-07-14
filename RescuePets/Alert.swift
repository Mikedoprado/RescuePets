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
    var username: String
    var userId: String
    var kindOfAlert: TypeOfThreat
    var timestamp: Int?
    var animal: KindOfAnimal
    var image: String?
    var city: String
    var address: String
    var description: String?
    var isActive: Bool
    var mapImage: String?
    
}

enum TypeOfThreat: String, Codable {
    case Rescue, Adoption, Wounded, Maltreatment, Desnutrition
}

enum KindOfAnimal: String,Codable {
    
    case Dog, Cat, Bird , Other
    
    var animal : String {
        switch self {
        case .Dog:
            return "Dog"
        case .Cat:
            return "Cat"
        case .Bird:
            return "Bird"
        case .Other:
            return "Other"
        }
    }
    
}

#if DEBUG
var user1 = User(username: "Michael",email: "mike@gmail.com")
var alertList = [
    Alert(id: "jsjdnakkw", username: user1.username, userId: "ishdlae" , kindOfAlert: .Rescue, animal: .Cat, image: "helloImage", city: "Medellin", address: "Calle 13 # 43D - 79", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque eget diam elementum, dictum leo quis, maximus velit. Donec tristique facilisis ipsum vitae lobortis.", isActive: true, mapImage: ""),
//    Alert(user: user1.name , kindOfAlert: .Adoption, timestamp: 2, animal: .cat, images: "helloImage", location: "Medellin", description: "He need to be adopted", isActive: false),
//    Alert(user: user1.name , kindOfAlert: .Desnutrition, timestamp: 5, animal: .bird, images: "helloImage", location: "Medellin", description: "He need food", isActive: false),
//    Alert(user: user1.name, kindOfAlert: .Maltreatment, timestamp: 7, animal: .other, images: "helloImage", location: "Medellin", description: "He need food", isActive: false)
]
#endif
