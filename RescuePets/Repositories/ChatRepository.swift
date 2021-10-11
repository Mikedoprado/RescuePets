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
    private var user = User()
    var userViewModel = UserViewModel()
    private var listenerRegistration: ListenerRegistration?
    private var lastSnapshot : QueryDocumentSnapshot?
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        
        userViewModel.userRepository.$user.compactMap {  user in
            user
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [weak self] user in
            self?.user = user
            self?.load()
        })
        .store(in: &cancellables)

    }
    
    func load() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
        }
        guard let currentUserId = user.id else {return}
        
        let query = DBInteract
            .store
            .collection(DBPath.helpers.path)
            .document(currentUserId)
            .collection(DBPath.chat.path)
        
        DBInteract.getData(listener: listenerRegistration, query: query, lastSnapshot: lastSnapshot) { [weak self] (lastSnapshot, items: [Chat]?) in
            guard let newChats = items else {return}
            self?.chats.append(contentsOf: newChats)
            self?.lastSnapshot = lastSnapshot
        }
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
