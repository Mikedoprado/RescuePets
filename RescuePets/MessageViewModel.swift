//
//  MessageViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/18/21.
//

import Combine
import Foundation


final class MessageViewModel: RepositoryMessageHelper , ObservableObject {
    
    var messageRepository : MessageRepository
    @Published var messagesViewModels : [MessageCellViewModel] = []
    
    
    private var cancellables = Set<AnyCancellable>()
    
    init(chatId: String) {
        messageRepository = MessageRepository(chatId: chatId)
        load()
    }

    func load() {
        messageRepository.$messages.map { messages in
            messages.map { message in
                MessageCellViewModel(message: message)
            }
        }
        .receive(on: DispatchQueue.main)
        .weakAssign(to: \.messagesViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func add(_ message: Message, chatId: String, from: String, to: String) {
        self.messageRepository.add(message, chatId: chatId, from: from, to: to)
    }
    
    func remove(_ message: Message) {
        
    }
    
    func update(_ message: Message, user: User) {
        
    }

}
