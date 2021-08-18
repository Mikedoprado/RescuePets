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
    func load(story: Story)
    func add(_ message: Message, story: Story)
    func remove(_ message: Message)
    func update(_ message: Message, user: User)
}

final class MessageRepository: RepositoryMessageHelper, ObservableObject {
    
    var pathMessages = "messages"
    var pathHelpers = "helpers"
    var store = Firestore.firestore()
    var auth = AuthenticationModel()
    
    @Published var messages : [Message] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        
    }
    
    func load(story: Story) {
        
        guard let storyId = story.id, let currentUserId = auth.currentUserId  else {return}

        let ref = store
            .collection(pathMessages)
            .document(currentUserId)
            .collection(storyId)
            .order(by: "timestamp", descending: true)

        ref.addSnapshotListener { snapshotStories, error in
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
    
    func add(_ message: Message, story: Story) {
        
        guard let currentUserId = auth.currentUserId else {return}
        
        if story.userId == currentUserId || story.userAcceptedStoryID == currentUserId {
            let messageId = UUID().uuidString
            guard let storyId = story.id else {return}
            
            let ref = store.collection(pathMessages).document(currentUserId).collection(storyId).document(messageId)
            
            do{
                try ref.setData(from: message)
            }catch let error{
                print(error.localizedDescription)
            }
        }
    }
    
    func remove(_ message: Message) {
        
    }
    
    func update(_ message: Message, user: User) {
        
    }
    
    
}
