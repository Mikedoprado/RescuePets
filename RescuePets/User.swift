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

struct User : Codable, Identifiable, Equatable {
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id && lhs.email == rhs.email
    }

    @DocumentID var id: String?
    var username: String?
    var email: String?
    var badges: [Badge]?
    var location: String?
    var kindOfUser: String?
    var profileImage: String?
    var amountStoriesCreated: Int?
    var amountStoriesAccepted: Int?
    
}

struct Badge: Codable, Hashable {
    
    var achievement: String
    var badgeImage : String?
    var isActive: Bool
    
    var image : Image {
        return isActive ? DesignImage.badgeActive.image : DesignImage.badgeInactive.image
    }
    
}

enum TypeOfUser : String, Codable {
    case animalist, foundation, casual, adopter
    
    var animal : String {
        switch self {
        case .animalist:
            return "Animalist"
        case .foundation:
            return "Foundation"
        case .casual:
            return "Casual"
        case .adopter:
            return "Adopter"
        }
    }
}

let badgesList = [
    Badge(achievement: "The new", badgeImage: "theNew", isActive: true),
    Badge(achievement: "You first story", badgeImage: "firstStory", isActive: false),
    Badge(achievement: "I can help", badgeImage: "help", isActive: false),
    Badge(achievement: "Helping in different place", badgeImage: "helpDifferentPlaces", isActive: false),
    Badge(achievement: "My first adoption", badgeImage: "fisrtAdoption", isActive: false),
    Badge(achievement: "Bringing to the vet", badgeImage: "toTheVet", isActive: false),
    Badge(achievement: "Sharing in the social network", badgeImage: "sharingInSocial", isActive: false),
    Badge(achievement: "Saving from the bad guys", badgeImage: "savingfromBadGuys", isActive: false),
    Badge(achievement: "Take all my food", badgeImage: "allMyFood", isActive: false),
    Badge(achievement: "I’m coming for you", badgeImage: "comingForYou", isActive: false),
    Badge(achievement: "Share the app with others", badgeImage: "shareWithOthers", isActive: false),
    Badge(achievement: "The idea is missing", badgeImage: "isMissing", isActive: false),
]
