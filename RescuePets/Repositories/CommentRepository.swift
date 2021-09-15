//
//  CommentRepository.swift
//  RescuePets
//
//  Created by Michael do Prado on 9/9/21.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol CommentHelper {
    
    func load(_ storyId: String)
    func add(_ comment: Comment, storyId: String)
    func remove(_ comment: Comment, storyId: String)
    
}

final class CommentRepository: CommentHelper, ObservableObject {
    
    @Published var comments : [Comment] = []
    private var listenerRegistration: ListenerRegistration?
    private var cancellables: Set<AnyCancellable> = []
    
    init(storyId: String) {
        load(storyId)
    }
    
    func load(_ storyId: String) {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
        }
        listenerRegistration = DBInteract.store
            .collection(DBPath.stories.path)
            .document(storyId)
            .collection(DBPath.comments.path).order(by: "timestamp", descending: false).addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else {return}
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                
                if !snapshot!.isEmpty {
                    self.comments = snapshot!.documents.compactMap({ document in
                        return try? document.data(as: Comment.self)
                    })
                }
            }
    }
    
    func add(_ comment: Comment, storyId: String) {
        let commentId = DBInteract.store.collection(DBPath.stories.path).document(storyId)
            .collection(DBPath.comments.path).document().documentID
        print(commentId)
        let ref = DBInteract.store
            .collection(DBPath.stories.path)
            .document(storyId)
            .collection(DBPath.comments.path).document(commentId)
        
        do {
            try ref.setData(from: comment)
        }catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func remove(_ comment: Comment, storyId: String) {
        
    }
    
}
