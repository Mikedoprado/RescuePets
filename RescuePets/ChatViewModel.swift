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
    @Published var chatId : String = ""
    
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
        .receive(on: DispatchQueue.main)
        .weakAssign(to: \.chatCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func add(_ chat: Chat) {
        self.chatRepository.add(chat)
        chatRepository.$chatId.map { id in
            return id
        }
        .receive(on: DispatchQueue.main)
        .weakAssign(to: \.chatId, on: self)
        .store(in: &cancellables)
    }
    
    
    func remove(_ chatId: String, acceptedStoryUser: String, ownerStoryUser: String) {
        self.chatRepository.remove(chatId, acceptedStoryUser: acceptedStoryUser, ownerStoryUser: ownerStoryUser)
    }
    
    
}
