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
    
    var pathStories = "stories"
    var pathMessages = "messages"
    var pathHelpers = "helpers"
    var pathChatMessages = "chatMessages"
    var store = Firestore.firestore()
    var auth = AuthenticationModel()
    
    @Published var chats : [Chat] = []
    @Published var chatId : String = ""
    private var listenerRegistration: ListenerRegistration?
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        load()
    }
    
    func load() {
        
        guard let currentUserId = auth.currentUserId else {return}
        
        let ref = store.collection(pathHelpers).document(currentUserId).collection(pathMessages).order(by: "timestamp", descending: true)
        
        ref.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else {return}
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            
            if !snapshot!.isEmpty{
                self.chats = snapshot!.documents.compactMap({ document in
                    try? document.data(as: Chat.self)
                })
            }
        }
    }
    
    
    func add(_ chat: Chat) {
       
        let chatId = store.collection(pathHelpers).document(chat.acceptedStoryUser).collection(pathMessages).document().documentID
        let refUserAccepted = store.collection(pathHelpers).document(chat.acceptedStoryUser).collection(pathMessages).document(chatId)
        let refUserOwner = store.collection(pathHelpers).document(chat.ownerStoryUser).collection(pathMessages).document(chatId)
        do{
            try refUserAccepted.setData(from: chat)
            try refUserOwner.setData(from: chat)
            self.chatId = chatId
        }catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func remove(_ chatId: String, acceptedStoryUser: String, ownerStoryUser: String) {
        
        let ref = store.collection(pathHelpers).document(acceptedStoryUser).collection(pathMessages).document(chatId).collection(pathChatMessages)
        
        ref.getDocuments {  [weak self] snapshot, error in
            guard let self = self else {return}
            
            if ((snapshot?.isEmpty) != nil){
                self.store.collection(self.pathHelpers).document(acceptedStoryUser).collection(self.pathMessages).document(chatId).delete()
                self.store.collection(self.pathHelpers).document(ownerStoryUser).collection(self.pathMessages).document(chatId).delete()
            }
        }

    }
    


}
