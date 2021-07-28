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
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        storyRepository.$stories.map { stories in
            stories.map { story in
                StoryCellViewModel(story: story)
            }
        }
        .assign(to: \.storyCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func load() {
       
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
