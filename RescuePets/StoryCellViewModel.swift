//  StoryCellViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/26/21.
//

import Combine
import SwiftUI

final class StoryCellViewModel: ObservableObject, Identifiable {
    
    @Published var story: Story
    var timestamp : String = ""
    
    @Published var acceptedStory = ""
    var id : String = ""
    var kindOfAnimal = ""
    var kindOfStory = ""
    var username = ""
    var userId = ""
    var city = ""
    var address = ""
    var description = ""
    var images = [String]()
    var latitude = 0.0
    var longitude = 0.0
    var numHelpers = 0
    var userAcceptedStoryID : [String] = []
    var presentImage = ""
    
    private var cancellables = Set<AnyCancellable>()

    init(story: Story) {
        
        self.story = story
        
        $story.compactMap { story in
            story.id
        }
        .weakAssign(to: \.id, on: self)
        .store(in: &cancellables)
        
        $story.compactMap { story in
            Timestamp.setupTimeStamp(time: story.timestamp)
        }
        .weakAssign(to: \.timestamp, on: self)
        .store(in: &cancellables)
        
        $story.sink{ story in
            if !story.userAcceptedStoryID!.isEmpty {
                if let currentUserId = DBInteract.currentUserId {
                    self.acceptedStory = (story.userAcceptedStoryID?.contains(currentUserId))! ? "I'm helping" : "I want to help"
                }
            }else{
                self.acceptedStory = "I want to help"
            } 
        }
        .store(in: &cancellables)

        $story.map{ story in
            story.animal.animal
        }
        .weakAssign(to: \.kindOfAnimal, on: self)
        .store(in: &cancellables)

        $story.map{ story in
            story.userId
        }
        .weakAssign(to: \.userId, on: self)
        .store(in: &cancellables)

        $story.map{ story in
            story.username
        }
        .weakAssign(to: \.username, on: self)
        .store(in: &cancellables)

        $story.map{ story in
            story.city
        }
        .weakAssign(to: \.city, on: self)
        .store(in: &cancellables)

        $story.map{ story in
            story.address
        }
        .weakAssign(to: \.address, on: self)
        .store(in: &cancellables)

        $story.compactMap{ story in
            story.description
        }
        .weakAssign(to: \.description, on: self)
        .store(in: &cancellables)

        $story.map{ story in
            story.address
        }
        .weakAssign(to: \.address, on: self)
        .store(in: &cancellables)

        $story.compactMap{ story in
            story.images
        }
        .weakAssign(to: \.images, on: self)
        .store(in: &cancellables)

        $story.compactMap{ story in
            story.userAcceptedStoryID
        }
        .weakAssign(to: \.userAcceptedStoryID, on: self)
        .store(in: &cancellables)

        $story.map{ story in
            story.longitude
        }
        .weakAssign(to: \.longitude, on: self)
        .store(in: &cancellables)

        $story.map{ story in
            story.latitude
        }
        .weakAssign(to: \.latitude, on: self)
        .store(in: &cancellables)

        $story.map{ story in
            story.kindOfStory
        }
        .weakAssign(to: \.kindOfStory, on: self)
        .store(in: &cancellables)
        
        $story.map{ story in
            story.userAcceptedStoryID?.count ?? 0
        }
        .weakAssign(to: \.numHelpers, on: self)
        .store(in: &cancellables)
        
        $story
            .sink { story in
                if let image = story.images?.first{
                    self.presentImage = image
                }
        }.store(in: &cancellables)
    }
}


