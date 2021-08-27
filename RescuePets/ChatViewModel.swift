//
//  ChatViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/24/21.
//

import Combine
import Foundation


final class ChatViewModel: RepositoryChatHelper , ObservableObject {

    @Published var chatRepository = ChatRepository()
    @Published var chatCellViewModels : [ChatCellViewModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        load()
    }
    func load() {
        chatRepository.$chats.map{ chats in
            chats.map { chat in
                return ChatCellViewModel(chat: chat)
            }
        }
        .weakAssign(to: \.chatCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func add(_ chat: Chat, complete: @escaping (String)->()) {
        self.chatRepository.add(chat, complete: { chatId in
            complete(chatId)
        })
    }
    
    
    func remove(_ chatId: String, acceptedStoryUser: String, ownerStoryUser: String) {
        self.chatRepository.remove(chatId, acceptedStoryUser: acceptedStoryUser, ownerStoryUser: ownerStoryUser)
    }
    
    
}
