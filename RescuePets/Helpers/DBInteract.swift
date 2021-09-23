//
//  DBInteract.swift
//  RescuePets
//
//  Created by Michael do Prado on 9/2/21.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class DBInteract {
    
    static var store = Firestore.firestore()
    static var auth = Auth.auth()
    static var storage = Storage.storage(url: "gs://rescue-pets-25f38.appspot.com/")
    static var currentUserId : String? {
        return (auth.currentUser?.uid != nil) ? auth.currentUser?.uid : nil 
    }
    
}


enum DBPath {
    
    case stories, messages, helpers, chatMessages, createdStories, acceptedStories, profilePictures, comments, chat
    
    var path : String {
        switch self {
        case .stories:
            return "stories"
        case .messages:
            return "messages"
        case .helpers:
            return "helpers"
        case .chatMessages:
            return "chatMessages"
        case .createdStories:
            return "createdStories"
        case .acceptedStories:
            return "acceptedStories"
        case .profilePictures:
            return "profilePicture"
        case .comments:
            return "comments"
        case .chat:
            return "chat"
        }
    }
}
