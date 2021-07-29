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
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        load()
        loadCreated()
        loadAccepted()
    }
    
    func load() {
        storyRepository.$stories.map { stories in
            stories.map { story in
                StoryCellViewModel(story: story)
            }
        }
        .assign(to: \.storyCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func loadCreated() {
        storyRepository.$storiesCreated.map { stories in
            stories.map { story in
                StoryCellViewModel(story: story)
            }
        }
        .assign(to: \.storyCellViewModelsCreated, on: self)
        .store(in: &cancellables)
    }
    func loadAccepted() {
        storyRepository.$storiesAccepted.map { stories in
            stories.map { story in
                StoryCellViewModel(story: story)
            }
        }
        .assign(to: \.storyCellViewModelsAccepted, on: self)
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
        self.storyRepository.update(story, user: user)
    }
    
    
}
