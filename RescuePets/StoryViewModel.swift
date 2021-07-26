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
        load()
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
    
    func add(_ story: Story, imageData: [Data]) {
        self.storyRepository.add(story, imageData: imageData)
    }
    
    func remove(_ story: Story) {
        
    }
    
    func update(_ story: Story) {
    
    }
    
    
}
