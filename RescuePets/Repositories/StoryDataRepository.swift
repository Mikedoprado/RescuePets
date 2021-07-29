//
//  StoryRepository.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/24/21.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage



protocol RepositoryStoryHelper {
    func load()
    func add(_ story: Story, imageData: [Data])
    func remove(_ story: Story)
    func update(_ story: Story, user: User)
}

final class StoryDataRepository: RepositoryStoryHelper, ObservableObject {
    
    @Published var stories : [Story] = []
    @Published var storiesCreated : [Story] = []
    @Published var storiesAccepted : [Story] = []
    let pathUser = "users"
    let pathStories = "stories"
    let pathCreatedStories = "createdStories"
    let pathAcceptedStories = "acceptedStories"
    let store = Firestore.firestore()
    let auth = Auth.auth()
    let storage = Storage.storage(url: "gs://rescue-pets-25f38.appspot.com/")
    
    init(){
        load()
        loadCreatedStories()
        loadAcceptedStories()
    }
    // MARK: load stories of the one location general stories in your city
    func load(){
        
        guard let currentUserId = auth.currentUser?.uid else {return}
        
        store.collection(pathUser).document(currentUserId).getDocument { [weak self] (snapshotUser, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            let user = try! snapshotUser?.data(as: User.self)
            guard let userLocation = user?.location else {return}
            
            let ref = self?.store.collection(self!.pathStories).order(by: "timestamp", descending: true).whereField("city", isEqualTo: userLocation)
            
            ref!.addSnapshotListener { snapshotStories, err in
                if err != nil {
                    print(err?.localizedDescription as Any)
                }
                if let snapshot = snapshotStories {
                    
                    if !snapshot.isEmpty{
                        self?.stories = snapshot.documents.compactMap({ document in
                                try? document.data(as: Story.self)
                        })
                    }
                }
            }
        }
    }
    // MARK: load stories created by the currentUser
    func loadCreatedStories(){
        
        guard let currentUserId = auth.currentUser?.uid else {return}
        
        let ref = store.collection(pathStories).order(by: "timestamp", descending: true).whereField("userId", isEqualTo: currentUserId)
        
        ref.addSnapshotListener { snapshotStories, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            if let snapshot = snapshotStories {
                
                if !snapshot.isEmpty{
                    self.storiesCreated = snapshot.documents.compactMap({ document in
                            try? document.data(as: Story.self)
                    })
                }
            }
        }
    }
    // MARK: load stories accepted by the currentUser
    func loadAcceptedStories(){
        
        guard let currentUserId = auth.currentUser?.uid else {return}
        
        let ref = store.collection(pathUser).document(currentUserId).collection(pathAcceptedStories).order(by: "timestamp", descending: true)
        
        ref.addSnapshotListener { snapshotStories, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            if let snapshot = snapshotStories {
                
                if !snapshot.isEmpty{
                    self.storiesAccepted = snapshot.documents.compactMap({ document in
                            try? document.data(as: Story.self)
                    })
                }
            }
        }
        
        
        
    }
    
    // MARK: creating a new story
    func add(_ story: Story, imageData: [Data]){
        
        guard let currentUserId = auth.currentUser?.uid else {return}
        let storyId = store.collection("stories").document().documentID
        
        do {
            try store.collection(pathStories).document(storyId).setData(from: story)
            let userstories = store.collection(pathUser).document(currentUserId).collection(pathCreatedStories).document(storyId)
            userstories.setData(["timestamp":story.timestamp])
            self.sendImageToDatabase(currentUserId: currentUserId, storyId: storyId, imageData: imageData)
            
        }catch{
            fatalError("the story couldn´t be saved")
        }
    }
    // MARK: deleting story in general and in the user
    func remove(_ story: Story) {
        
        guard let currentUserId = auth.currentUser?.uid, let storyId = story.id else {return}
        
        store.collection(pathStories).document(storyId).delete { [weak self] error in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            self?.store.collection(self!.pathUser).document(currentUserId).collection(self!.pathCreatedStories).document(storyId).delete { error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
            }
            
            if story.userAcceptedStoryID != nil {
                self?.store.collection(self!.pathUser).document(story.userAcceptedStoryID!).collection(self!.pathAcceptedStories).document(storyId).delete { error in
                    if error != nil {
                        print(error?.localizedDescription as Any)
                    }
                }
            }
        }
//             delete element from the storage to
    }
    
    func update(_ story: Story, user: User) {
        let isActive = story.isActive
        
        switch isActive {
        case true:
            store.collection(pathStories).document(story.id!).updateData(["isActive":true, "userAcceptedStoryID": user.id as Any])
            do{
                try store.collection(pathUser).document(user.id!).collection(pathAcceptedStories).document(story.id!).setData(from: story)
                store.collection(pathUser).document(user.id!).collection(pathAcceptedStories).document(story.id!).updateData(["userAcceptedStoryID": user.id as Any])
            }catch{
                fatalError("something have happened")
            }
        case false:
            store.collection(pathStories).document(story.id!).updateData(["isActive":false])
            if story.userAcceptedStoryID != nil{
                store.collection(pathUser).document(user.id!).collection(pathAcceptedStories).document(story.id!).delete(completion: { error in
                    if error != nil{
                        print(error?.localizedDescription as Any)
                        return
                    }
                })
            }
        }
    }
    
    func sendImageToDatabase(currentUserId: String ,storyId: String, imageData:[Data]){
        
        let ref = storage.reference()
        
        let totalRef = ref.child(currentUserId).child(storyId)
        var imageUrlString : [String] = []
        
        for data in imageData {
            let imagePetId = NSUUID().uuidString
            let refImageId = totalRef.child(imagePetId)
            _ = refImageId.putData(data, metadata: nil, completion: { _, error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                refImageId.downloadURL { [weak self] url, err in
                    guard let downloadUrl = url?.absoluteString else {return}
                    imageUrlString.append(downloadUrl)
                    if imageUrlString.count == imageData.count{
                        self?.store.collection(self!.pathStories).document(storyId).updateData(["images": imageUrlString])
                    }
                }
            })
        }
        
    }
    
    func setupTimeStamp(time: Int) -> String {
        
        let timestampDate = Date(timeIntervalSince1970: Double(time))
        let now = Date()
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
        let diff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
        
        var timeText = ""
        
        if diff.second! <= 0 {
            timeText = "Now"
        }
        if diff.second! > 0 && diff.minute! == 0 {
            timeText = (diff.second == 1) ? "\(diff.second!) second ago" : "\(diff.second!) seconds ago"
        }
        if diff.minute! > 0 && diff.hour! == 0 {
            timeText = (diff.second == 1) ? "\(diff.minute!) minute ago" : "\(diff.minute!) minutes ago"
        }
        if diff.hour! > 0 && diff.day! == 0 {
            timeText = (diff.hour == 1) ? "\(diff.hour!) hour ago" : "\(diff.hour!) hours ago"
        }
        if diff.day! > 0 && diff.weekOfMonth! == 0 {
            timeText = (diff.day == 1) ? "\(diff.day!) day ago" : "\(diff.day!) days ago"
        }
        if diff.weekOfMonth! > 0 {
            timeText = (diff.weekOfMonth == 1) ? "\(diff.weekOfMonth!) week ago" : "\(diff.weekOfMonth!) weeks ago"
        }
        
        return timeText
    }
    
}
