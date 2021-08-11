//
//  StoryViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/26/21.
//

import Foundation
import Combine

final class StoryViewModel: RepositoryStoryHelper, ObservableObject {
    
    @Published var storyRepository =  StoryDataRepository()
    @Published var storyCellViewModels : [StoryCellViewModel] = []
    @Published var storyCellViewModelsCreated : [StoryCellViewModel] = []
    @Published var storyCellViewModelsAccepted : [StoryCellViewModel] = []
    @Published var amountCreatedStories : Int = 0
    @Published var amountAcceptedStories : Int = 0
    private var cancellables = Set<AnyCancellable>()
    
    
    
    init(){
        load()
        loadCreated()
        loadAccepted()
        amountStories()
    }
    
    func load() {
        storyRepository.$stories.map { stories in
            stories.map { story in
                StoryCellViewModel(story: story)
            }
        }
        .weakAssign(to: \.storyCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func loadCreated() {
        storyRepository.$storiesCreated.map { stories in
            stories.map { story in
                StoryCellViewModel(story: story)
            }
        }
        .weakAssign(to: \.storyCellViewModelsCreated, on: self)
        .store(in: &cancellables)
    }
    func loadAccepted() {
        storyRepository.$storiesAccepted.map { stories in
            stories.map { story in
                StoryCellViewModel(story: story)
            }
        }
        .weakAssign(to: \.storyCellViewModelsAccepted, on: self)
        .store(in: &cancellables)
    }
    
    fileprivate func amountStories() {
        $storyCellViewModelsCreated.map{ stories in
            stories.count
        }
        .weakAssign(to: \.amountCreatedStories, on: self)
        .store(in: &cancellables)
        
        $storyCellViewModelsAccepted.map{ stories in
            stories.count
        }
        .weakAssign(to: \.amountAcceptedStories, on: self)
        .store(in: &cancellables)
    }
    
    func add(_ story: Story, imageData: [Data]) {
        self.storyRepository.add(story, imageData: imageData)
    }
    
    func remove(_ story: Story) {
        if let index = storyCellViewModels.firstIndex(where: {$0.id == story.id}){
            storyCellViewModels.remove(at: index)
            self.storyRepository.remove(story)
        }
    }
    
    func update(_ story: Story, user: User) {
        if let index = storyCellViewModelsAccepted.firstIndex(where: {$0.id == story.id}){
            storyCellViewModelsAccepted.remove(at: index)
        }
        self.storyRepository.update(story, user: user)
    }
}
