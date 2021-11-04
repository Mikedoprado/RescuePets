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
    func load(chatId: String)
    func add(_ message: Message, chatId: String?, complete: @escaping (String)->())
    func remove(_ message: Message)
    func update(_ message: Message, user: User)
}

final class MessageRepository: RepositoryMessageHelper, ObservableObject {
    
    @Published var chatId : String = ""
    
    @Published var messages : [Message] = []
    private var cancellables: Set<AnyCancellable> = []
    private var listenerRegistration: ListenerRegistration?
    private var lastSnapshot : QueryDocumentSnapshot?
    
    init(){
        $chatId
            .sink { [weak self] chatId in
            if chatId != ""{
                self?.load(chatId: chatId)
            }
        }
            .store(in: &cancellables)
    }
    
    func load(chatId: String) {
        
        if listenerRegistration != nil {
            listenerRegistration?.remove()
        }
        guard let currentUserId = DBInteract.currentUserId else {return}
        
        let query = DBInteract
            .store
            .collection(DBPath.helpers.path)
            .document(currentUserId)
            .collection(DBPath.chat.path)
            .document(chatId)
            .collection(DBPath.messages.path)
            .order(by: "timestamp", descending: false)
//            .limit(to: 10)

        DBInteract.getData(listener: listenerRegistration, query: query, lastSnapshot: lastSnapshot) { [weak self] (lastSnapshot, items: [Message]?) in
            guard let messages = items else {return}
            self?.messages = messages
            self?.lastSnapshot = lastSnapshot
        }
    }
    
    func add(_ message: Message, chatId: String?,complete: @escaping (String)->()) {
        
        var id = ""
        let timestamp = Int(Date().timeIntervalSince1970)

        if chatId != "" && chatId != nil{
            id = chatId!
            self.saveMessage(id: id, message: message)
            let refFromUser = DBInteract.store.collection(DBPath.helpers.path).document(message.from).collection(DBPath.chat.path).document(id)
            let refToUser = DBInteract.store.collection(DBPath.helpers.path).document(message.to).collection(DBPath.chat.path).document(id)
            refFromUser.updateData(["lastComment": message.text])
            refToUser.updateData(["lastComment": message.text]) 
        }else{
            createChat(id: id, from: message.from, to: message.to, timestamp: timestamp, lastComment: message.text, complete: { [weak self] id in
                self?.saveMessage(id: id, message: message)
                self?.chatId = id
                complete(id)
            })
        }
    }
    
    
    func remove(_ message: Message) {
        
    }
    
    func update(_ message: Message, user: User) {
        
    }
    
    deinit{
        print("deinit messageRepository")
    }
    
}

extension MessageRepository {
    
    fileprivate func createChat( id: String,  from: String,  to: String, timestamp: Int, lastComment: String, complete: @escaping (String)->()) {
        
        let id = DBInteract.store.collection(DBPath.helpers.path).document(from).collection(DBPath.chat.path).document().documentID
        let chat = Chat(id: id, owners: [from, to], timestamp: timestamp, lastComment: lastComment, isReaded: [from: true, to: false])
        let refFromUser = DBInteract.store.collection(DBPath.helpers.path).document(from).collection(DBPath.chat.path).document(id)
        let refToUser = DBInteract.store.collection(DBPath.helpers.path).document(to).collection(DBPath.chat.path).document(id)
        do{
            try refFromUser.setData(from: chat)
            try refToUser.setData(from: chat)
            complete(id)
        }catch let error{
            fatalError(error.localizedDescription)
        }
    }
    
    fileprivate func saveMessage(id: String, message: Message) {
        let messageId = DBInteract.store.collection(DBPath.helpers.path).document(message.from).collection(DBPath.chat.path).document(id).collection(DBPath.messages.path).document().documentID
        let refFromUser = DBInteract.store.collection(DBPath.helpers.path).document(message.from).collection(DBPath.chat.path).document(id).collection(DBPath.messages.path).document(messageId)
        let refToUser = DBInteract.store.collection(DBPath.helpers.path).document(message.to).collection(DBPath.chat.path).document(id).collection(DBPath.messages.path).document(messageId)
        
        do{
            try refFromUser.setData(from: message)
            try refToUser.setData(from: message)
            
        }catch let error{
            fatalError(error.localizedDescription)
        }
    }
}
