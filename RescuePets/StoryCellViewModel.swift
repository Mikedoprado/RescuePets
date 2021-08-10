//
//  StoryCellViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/26/21.
//

import Combine
import SwiftUI

final class StoryCellViewModel: ObservableObject, Identifiable {
    
    @Published var story: Story
    @Published var storyRepository = StoryDataRepository()
    @Published var timestamp : String = ""
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
    var userAcceptedStoryID = ""
    
    private var cancellables = Set<AnyCancellable>()

    init(story: Story) {
        self.story = story
        
        $story.compactMap { story in
            story.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
        
        $story.compactMap{ [weak self] story in
            self?.storyRepository.setupTimeStamp(time: story.timestamp)
        }
        .assign(to: \.timestamp, on: self)
        .store(in: &cancellables)
        
        $story.map{ story in
            story.isActive ? "storyAcept" : "storyAdd"
        }
        .assign(to: \.acceptedStory, on: self)
        .store(in: &cancellables)
        
        $story.map{ story in
            story.animal.animal
        }
        .assign(to: \.kindOfAnimal, on: self)
        .store(in: &cancellables)
        
        $story.map{ story in
            story.userId
        }
        .assign(to: \.userId, on: self)
        .store(in: &cancellables)
        
        $story.map{ story in
            story.username
        }
        .assign(to: \.username, on: self)
        .store(in: &cancellables)
        
        $story.map{ story in
            story.city
        }
        .assign(to: \.city, on: self)
        .store(in: &cancellables)
        
        $story.map{ story in
            story.address
        }
        .assign(to: \.address, on: self)
        .store(in: &cancellables)
        
        $story.compactMap{ story in
            story.description
        }
        .assign(to: \.description, on: self)
        .store(in: &cancellables)
        
        $story.map{ story in
            story.address
        }
        .assign(to: \.address, on: self)
        .store(in: &cancellables)
        
        $story.compactMap{ story in
            story.images
        }
        .assign(to: \.images, on: self)
        .store(in: &cancellables)
        
        $story.compactMap{ story in
            story.userAcceptedStoryID
        }
        .assign(to: \.userAcceptedStoryID, on: self)
        .store(in: &cancellables)
        
        $story.map{ story in
            story.longitude
        }
        .assign(to: \.longitude, on: self)
        .store(in: &cancellables)
        
        $story.map{ story in
            story.latitude
        }
        .assign(to: \.latitude, on: self)
        .store(in: &cancellables)
        
        $story.map{ story in
            story.kindOfStory
        }
        .assign(to: \.kindOfStory, on: self)
        .store(in: &cancellables)
        
    }
    
}
