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
    func load()
    func add(_ chat: Chat)
    func remove(_ chatId: String, acceptedStoryUser: String, ownerStoryUser: String)
//    func update(_ chat: Chat, user: User)
}

final class ChatRepository: RepositoryChatHelper, ObservableObject {
    
    @Published var chats : [Chat] = []
    @Published var chatId : String = ""
    private var listenerRegistration: ListenerRegistration?
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        load()
    }
    
    func load() {
        
        if listenerRegistration != nil {
            listenerRegistration?.remove()
        }
        
        guard let currentUserId = DBInteract.auth.currentUser?.uid else {return}
        listenerRegistration = DBInteract.store.collection(DBPath.helpers.path).document(currentUserId).collection(DBPath.messages.path).order(by: "timestamp", descending: true).addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else {return}
            if error != nil {
                print(error?.localizedDescription as Any)
            } 
            
            if !snapshot!.isEmpty{
                self.chats = snapshot!.documents.compactMap({ document in
                    return try? document.data(as: Chat.self)
                })
            }
        }
    }
    
    
    func add(_ chat: Chat) {
       
        let chatId = DBInteract.store.collection(DBPath.helpers.path).document(chat.acceptedStoryUser).collection(DBPath.messages.path).document().documentID
        let refUserAccepted = DBInteract.store.collection(DBPath.helpers.path).document(chat.acceptedStoryUser).collection(DBPath.messages.path).document(chatId)
        let refUserOwner = DBInteract.store.collection(DBPath.helpers.path).document(chat.ownerStoryUser).collection(DBPath.messages.path).document(chatId)
        do{
            try refUserAccepted.setData(from: chat)
            try refUserOwner.setData(from: chat)
            self.chatId = chatId
        }catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func remove(_ chatId: String, acceptedStoryUser: String, ownerStoryUser: String) {
        
        let ref = DBInteract.store.collection(DBPath.helpers.path).document(acceptedStoryUser).collection(DBPath.messages.path).document(chatId).collection(DBPath.chatMessages.path)
        
        ref.getDocuments { snapshot, error in
            if ((snapshot?.isEmpty) != nil){
                DBInteract.store.collection(DBPath.helpers.path).document(acceptedStoryUser).collection(DBPath.messages.path).document(chatId).delete()
                DBInteract.store.collection(DBPath.helpers.path).document(ownerStoryUser).collection(DBPath.messages.path).document(chatId).delete()
            }
        }

    }
    


}
