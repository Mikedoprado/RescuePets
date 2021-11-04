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


struct Story : Codable, Identifiable {

    @DocumentID var id: String?
    var username: String
    var userId: String
    var kindOfStory: String
    var timestamp: Int
    var animal: String
    var images: [String]?
    var imageData: [Data]?
    var city: String
    var address: String
    var description: String?
    var latitude: Double
    var longitude: Double
    var userAcceptedStoryID: [String]
    var chatId : String?
    
}

enum TypeOfThreat: String, Codable {
    case Rescue, Adoption, Wounded, Maltreatment, Desnutrition, Malnourished
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

class StoryBuilder {

    public private(set) var username : String = ""
    public private(set) var userId : String = ""
    public private(set) var city: String = ""
    public private(set) var address: String = ""
    public private(set) var description: String = ""
    public private(set) var latitude: Double = 0.0
    public private(set) var longitude: Double = 0.0
    public private(set) var imageData: [Data] = []
    public private(set) var userAcceptedStoryID: [String] = []
    public private(set) var images: [String]?
    public private(set) var animal : String = ""
    public private(set) var kindOfStory: String = ""
    public private(set) var timestamp: Int = 0
    
    
    public func setUser(user: User) -> StoryBuilder {
        if let username = user.username, let userId = user.id {
            self.username = username
            self.userId = userId
        }
        return self
    }
    
    public func setCurrentLocation(locationManager: LocationManager) -> StoryBuilder {
        if let latitude = locationManager.location?.coordinate.latitude,
           let longitude = locationManager.location?.coordinate.longitude {
            
            self.city = locationManager.city.lowercased()
            self.address = locationManager.address
            self.latitude = latitude
            self.longitude = longitude
        }
        return self
    }
    
    public func setDataImages(data: [Data]) -> StoryBuilder {
        self.imageData = data
        return self
    }
    
    public func setImages(images: [String]) -> StoryBuilder{
        self.images = images
        return self
    }
    
    public func setDescription(text: String) -> StoryBuilder{
        self.description = text
        return self
    }
    
    public func setAnimal(kindOfAnimal: String) -> StoryBuilder{
        self.animal = kindOfAnimal
        return self
    }
    
    public func setKindOfStory(kindOfStory: String) -> StoryBuilder{
        self.kindOfStory = kindOfStory
        return self
    }
    
    public func setTimestamp(timestamp: Int) -> StoryBuilder{
        self.timestamp = timestamp
        return self
    }

    public func build() -> Story {
        return Story(
            username: self.username,
            userId: self.userId,
            kindOfStory: self.kindOfStory,
            timestamp: self.timestamp,
            animal: self.animal,
            imageData: self.imageData,
            city: self.city,
            address: self.address,
            description: self.description,
            latitude: self.latitude,
            longitude: self.longitude,
            userAcceptedStoryID: self.userAcceptedStoryID,
            chatId: nil
        )
    }
}


