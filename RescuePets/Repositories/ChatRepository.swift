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
    func remove(_ chatId: String, from: String, to: String)
}

final class ChatRepository: RepositoryChatHelper, ObservableObject {
    
    @Published var chats : [Chat] = []

    private var listenerRegistration: ListenerRegistration?
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        load()
    }
    
    func load() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
        }
        guard let currentUserId = DBInteract.currentUserId else {return}
        
        listenerRegistration = DBInteract
            .store
            .collection(DBPath.helpers.path)
            .document(currentUserId)
            .collection(DBPath.chat.path)
            .addSnapshotListener({ [weak self] snapshot, error in
                guard let self = self else {return}
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                
                if snapshot != nil && !snapshot!.isEmpty{
                    self.chats = snapshot!.documents.compactMap({ document in
                        try? document.data(as: Chat.self)
                    })
                }
        })
    }
    
    
    func add(_ chat: Chat) {
       

        
    }
    
    func remove(_ chatId: String, from: String, to: String) {
        


    }
    
    
    func checkChatExist(userId: String, complete: @escaping (String)->()){
        guard let currentUserId = DBInteract.currentUserId else {return}
        DBInteract
            .store
            .collection(DBPath.helpers.path)
            .document(currentUserId)
            .collection(DBPath.chat.path)
            .whereField("owners", arrayContains: userId)
            .getDocuments { snapshot, error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                
                if !snapshot!.isEmpty{
                    if let chatId = snapshot?.documents.compactMap({ document in
                        document.documentID
                    }){
                        complete(chatId.first!)
                    }
                    
                }else{
                    complete("")
                }
            }
    }
    
    deinit{
        print("deinit Chat repository")
    }


}
