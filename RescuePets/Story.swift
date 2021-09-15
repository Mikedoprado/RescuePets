//
//  story.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/22/21.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import MapKit

struct Story : Codable, Identifiable {

    @DocumentID var id: String?
    var username: String
    var userId: String
    var kindOfStory: String
    var timestamp: Int
    var animal: KindOfAnimal
    var images: [String]?
    var city: String
    var address: String
    var description: String?
    var latitude: Double
    var longitude: Double
    var userAcceptedStoryID: [String : Bool]?
    var chatId : String?
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

struct Place : Identifiable{
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}


