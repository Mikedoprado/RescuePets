//
//  ChatRepository.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/24/21.
//

import Combine
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol RepositoryChatHelper {
    func load(chatId: String)
    func add(_ chat: Chat)
    func remove(_ chatId: String, from: String, to: String)
}

final class ChatRepository: RepositoryChatHelper, ObservableObject {
    
    @Published var chats : [Chat] = []

    private var listenerRegistration: ListenerRegistration?
    private var cancellables: Set<AnyCancellable> = []
    
    init(chatId: String) {
        load(chatId: chatId)
    }
    
    func load(chatId: String) {
        

    }
    
    
    func add(_ chat: Chat) {
       

        
    }
    
    func remove(_ chatId: String, from: String, to: String) {
        


    }
    


}
