//
//  MessageViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/18/21.
//

import Combine
import Foundation


final class MessageViewModel: RepositoryMessageHelper , ObservableObject {
    
    var messageRepository = MessageRepository()
    @Published var messagesViewModels : [MessageCellViewModel] = []
    @Published var chatId : String = ""
    @Published var isChatIdActive : Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $chatId
            .sink { [weak self] chatId in
            if chatId != ""{
                self?.messageRepository.chatId = chatId
                self?.load(chatId: chatId)
            }
        }
            .store(in: &cancellables)
    }

    func load(chatId: String) {
        messageRepository.$messages.map { messages in
            messages.map { message in
                MessageCellViewModel(message: message)
            }
        }
        .receive(on: DispatchQueue.main)
        .weakAssign(to: \.messagesViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func add(_ message: Message, chatId: String?, complete: @escaping (String)->()) {
        self.messageRepository.add(message, chatId: chatId, complete: { [weak self] id in
            if self?.chatId == ""{
                self?.chatId = id
            }
            complete(id)
        })
    }
    
    func remove(_ message: Message) {
        
    }
    
    func update(_ message: Message, user: User) {
        
    }
    
    deinit{
        print("deinit MessageViewModel")
    }

}
