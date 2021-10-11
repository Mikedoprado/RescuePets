//
//  ChatViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/24/21.
//

import Combine
import Foundation


final class ChatViewModel: RepositoryChatHelper , ObservableObject {

    var chatRepository = ChatRepository()
    @Published var chatCellViewModels : [ChatCellViewModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        load()
    }
    
    func load() {
        chatRepository.$chats.map{ chats in
            chats.map { chat in
                ChatCellViewModel(chat: chat)
            }
        }
        .weakAssign(to: \.chatCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func load(userId: String) {}
    
    func add(_ chat: Chat) {
        self.chatRepository.add(chat)
    }
    
    
    func remove(_ chatId: String, from: String, to: String) {
        self.chatRepository.remove(chatId, from: from, to: to)
    }
    
    deinit{
        print("deinit ChatViewModel")
    }
}
