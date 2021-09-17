//
//  ChatViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/24/21.
//

import Combine
import Foundation


final class ChatViewModel: RepositoryChatHelper , ObservableObject {
    
    var chatRepository : ChatRepository?
    @Published var chatCellViewModels : [ChatCellViewModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(chatId: String) {
        load(chatId: chatId)
    }
    
    func load(chatId: String) {
        
        chatRepository = ChatRepository(chatId: chatId)
        
        chatRepository?.$chats.map{ chats in
            chats.map { chat in
                return ChatCellViewModel(chat: chat)
            }
        }
        .receive(on: DispatchQueue.main)
        .weakAssign(to: \.chatCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func add(_ chat: Chat) {
        self.chatRepository?.add(chat)
    }
    
    
    func remove(_ chatId: String, from: String, to: String) {
        self.chatRepository?.remove(chatId, from: from, to: to)
    }
    
    
}
