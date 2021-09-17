//
//  MessageRepsitory.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/13/21.
//

import Combine
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol RepositoryMessageHelper {
    func load()
    func add(_ message: Message, chatId: String, from: String, to: String)
    func remove(_ message: Message)
    func update(_ message: Message, user: User)
}

final class MessageRepository: RepositoryMessageHelper, ObservableObject {
    
    var chatId : String
    
    @Published var messages : [Message] = []
    private var cancellables: Set<AnyCancellable> = []
    private var listenerRegistration: ListenerRegistration?
    
    init(chatId: String){
        self.chatId = chatId
        load()
    }
    
    func load() {
        

    }
    
    func add(_ message: Message, chatId: String, from: String, to: String) {
        
        
    }
    
    
    func remove(_ message: Message) {
        
    }
    
    func update(_ message: Message, user: User) {
        
    }
    
    
}
