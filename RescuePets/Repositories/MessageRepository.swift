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
    
    var pathStories = "stories"
    var pathMessages = "messages"
    var pathHelpers = "helpers"
    var store = Firestore.firestore()
    var auth = AuthenticationModel()
    var chatId : String
    
    @Published var messages : [Message] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init(chatId: String){
        self.chatId = chatId
        load()
    }
    
    func load() {
        guard let currentUserId = auth.currentUserId else {return}
        let ref = store
            .collection(pathHelpers)
            .document(currentUserId)
            .collection(pathMessages)
            .document(chatId)
            .collection("chat")
            .order(by: "timestamp", descending: false)
        
        ref.addSnapshotListener { [weak self] snapshotStories, error in
            guard let self = self else {return}
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            if let snapshot = snapshotStories {
                if !snapshot.isEmpty{
                    self.messages = snapshot.documents.compactMap({ document in
                        try? document.data(as: Message.self)
                    })
                }
            }
        }
    }
    
    func add(_ message: Message, chatId: String, from: String, to: String) {
        
        let messageId = store
            .collection(pathHelpers)
            .document(from)
            .collection(pathMessages)
            .document(chatId).collection("chat")
            .document().documentID
        
        let refFrom = store
            .collection(pathHelpers)
            .document(from)
            .collection(pathMessages)
            .document(chatId)
            .collection("chat")
            .document(messageId)
        
        let refTo = store
            .collection(pathHelpers)
            .document(to)
            .collection(pathMessages)
            .document(chatId)
            .collection("chat")
            .document(messageId)
        
        do{
            try refFrom.setData(from: message)
            try refTo.setData(from: message)
        }catch let error{
            print(error.localizedDescription)
        }
        
    }
    
    
    func remove(_ message: Message) {
        
    }
    
    func update(_ message: Message, user: User) {
        
    }
    
    
}
