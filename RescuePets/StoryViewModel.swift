//
//  StoryViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/26/21.
//

import Foundation
import Combine

final class StoryViewModel: RepositoryStoryHelper, ObservableObject {
    
    var storyRepository =  StoryDataRepository()
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
        }.sink(receiveValue: { [weak self] stories in
            self?.storyCellViewModels = stories
        })
        .store(in: &cancellables)
    }
    
    func loadCreated() {
        storyRepository.$storiesCreated.map { stories in
            stories.map { story in
                StoryCellViewModel(story: story)
            }
        }.sink(receiveValue: { [weak self] storiesCreated in
            self?.storyCellViewModelsCreated = storiesCreated
        })
        .store(in: &cancellables)
    }
    func loadAccepted() {
        storyRepository.$storiesAccepted.map { stories in
            stories.map { story in
                StoryCellViewModel(story: story)
            }
        }.sink(receiveValue: { [weak self] storiesAccepted in
            self?.storyCellViewModelsAccepted = storiesAccepted
        })
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
    
    func add(_ story: Story) {
        storyRepository.add(story)
    }
    
    func remove(_ story: Story) {
        if let index = storyCellViewModels.firstIndex(where: {$0.id == story.id}){
            storyCellViewModels.remove(at: index)
            storyRepository.remove(story)
        }
    }
    
    func update(_ storyCellViewModel: StoryCellViewModel){
        storyRepository.update(storyCellViewModel)
    }
    
    deinit{
        print("deinit storyViewModel")
    }
}
