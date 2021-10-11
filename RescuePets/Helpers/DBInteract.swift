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
    
    static func getData<T:Decodable>(listener: ListenerRegistration?, query: Query, lastSnapshot: QueryDocumentSnapshot?, complete: @escaping (QueryDocumentSnapshot, [T]?)->()) {
         
        query.addSnapshotListener { snapshotStories, err in
                
                if err != nil, snapshotStories == nil {
                    print(err?.localizedDescription as Any)
                }
                if let snapshot = snapshotStories {
                    if lastSnapshot != snapshot.documents.last || lastSnapshot == nil{
                        guard let lastQuery = snapshot.documents.last else { return }
                        
                        if !snapshot.isEmpty{
                            let items = snapshot.documents.compactMap({ document in
                                try? document.data(as: T.self)
                            })
                            complete(lastQuery, items)
                        }
                    }
                }
            }
        
    }
    
    static func sendImageToDatabase(currentUserId: String ,storyId: String, imageData:[Data], complete: @escaping ([String])->()){
        
        let ref = DBInteract.storage.reference()
        
        let totalRef = ref.child(currentUserId).child(storyId)
        var imageUrlString : [String] = []
        
        for data in imageData {
            let imagePetId = NSUUID().uuidString
            let refImageId = totalRef.child(imagePetId)
            _ = refImageId.putData(data, metadata: nil, completion: { _, error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                refImageId.downloadURL { url, err in
                    guard let downloadUrl = url?.absoluteString else {return}
                    imageUrlString.append(downloadUrl)
                    if imageUrlString.count == imageData.count{
                        complete(imageUrlString)
                    }
                }
            })
        }
    }
    
    private init(){}
    
}


enum DBPath {
    
    case stories, messages, helpers, chatMessages, createdStories, acceptedStories, profilePictures, comments, chat, timestamp, city, userId, userAcceptedStoryID
    
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
        case .timestamp:
            return "timestamp"
        case .city:
            return "city"
        case .userId:
            return "userId"
        case .userAcceptedStoryID:
            return "userAcceptedStoryID"
        }
    }
}
