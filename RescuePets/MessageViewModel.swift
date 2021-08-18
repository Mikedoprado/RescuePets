//
//  MessageViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/18/21.
//

import Combine
import SwiftUI


final class MessageViewModel: RepositoryMessageHelper , ObservableObject {
    
    @Published var messageRepository = MessageRepository()
    @Published var messages : [MessageCellViewModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(story: Story) {
        load(story: story)
    }
    
    func load(story: Story) {
        
    }
    
    func add(_ message: Message, story: Story) {
        self.messageRepository.add(message, story: story)
    }
    
    func remove(_ message: Message) {
        
    }
    
    func update(_ message: Message, user: User) {
        
    }

}
