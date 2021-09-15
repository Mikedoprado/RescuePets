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
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var userViewModel = UserViewModel()
    private var listenerRegistrationStory: ListenerRegistration?
    private var listenerRegistrationStoryAccepted: ListenerRegistration?
    private var listenerRegistrationStoryCreated: ListenerRegistration?
    private var user = User()
    
    init(){
        
        userViewModel.userRepository.$user.compactMap {  user in
            user
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [weak self] user in
//            print(user.location)
            self?.user = user
            self?.load()
            self?.loadAcceptedStories()
            self?.loadCreatedStories()
        })
        .store(in: &cancellables)
        
    }
    
    // MARK: load stories of the one location general stories in your city
    
    func load(){
        
        if listenerRegistrationStory != nil {
            listenerRegistrationStory?.remove()
        }
        guard let userLocation = user.location else {return}
        
        listenerRegistrationStory = DBInteract.store
            .collection(DBPath.stories.path)
            .order(by: "timestamp", descending: true)
            .whereField("city", isEqualTo: userLocation)
            .addSnapshotListener { [weak self] snapshotStories, err in
                guard let self = self else {return}
                if err != nil, snapshotStories == nil {
                    print(err?.localizedDescription as Any)
                }
                if let snapshot = snapshotStories {
                    
                    if !snapshot.isEmpty{
                        self.stories = snapshot.documents.compactMap({ document in
                            try? document.data(as: Story.self)
                        })
                    }
                }
            }
    }
    // MARK: load stories created by the currentUser
    func loadCreatedStories(){
        
        if listenerRegistrationStoryCreated != nil {
            listenerRegistrationStoryCreated?.remove()
        }
        
        guard let userID = user.id else {return}
        
        listenerRegistrationStoryCreated = DBInteract.store
            .collection(DBPath.stories.path)
            .order(by: "timestamp", descending: true)
            .whereField("userId", isEqualTo: userID)
            .addSnapshotListener { [weak self] snapshotStories, error in
                guard let self = self else {return}
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
        
        if listenerRegistrationStoryAccepted != nil {
            listenerRegistrationStoryAccepted?.remove()
        }
        
        guard let userID = user.id else {return}
        listenerRegistrationStoryAccepted = DBInteract.store
            .collection(DBPath.helpers.path)
            .document(userID)
            .collection(DBPath.acceptedStories.path)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshotStories, error in
                guard let self = self else {return}
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
        
        guard let userID = user.id else {return}
        let storyId = DBInteract.store.collection(DBPath.stories.path).document().documentID
        self.sendImageToDatabase(currentUserId: userID, storyId: storyId, imageData: imageData, complete: { arrayImages in
            do {
                var newStory = story
                newStory.images = arrayImages
                try DBInteract.store.collection(DBPath.stories.path).document(storyId).setData(from: newStory)
                let helpersStories = DBInteract.store.collection(DBPath.helpers.path).document(userID).collection(DBPath.createdStories.path).document(storyId)
                helpersStories.setData(["timestamp":story.timestamp])
            }catch{
                fatalError("the story couldn´t be saved")
            }
        })
        
    }
    // MARK: deleting story in general and in the user
    func remove(_ story: Story) {
        
        guard let userID = user.id, let storyId = story.id else {return}
        
        DBInteract.store.collection(DBPath.stories.path).document(storyId).delete {  error in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            DBInteract.store.collection(DBPath.helpers.path).document(userID).collection(DBPath.createdStories.path).document(storyId).delete { error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
            }
            
            if let dictUser = story.userAcceptedStoryID, !story.userAcceptedStoryID!.isEmpty {
                dictUser.forEach({ (userId: String, value: Bool) in
                    DBInteract.store.collection(DBPath.helpers.path).document(userId).collection(DBPath.acceptedStories.path).document(storyId).delete { error in
                        if error != nil {
                            print(error?.localizedDescription as Any)
                        }
                    }
                })
            }
        }
        //             delete element from the storage to
    }
    
    func update(_ story: Story, user: User) {
        
        guard let userId = user.id, let storyId = story.id else {return}
        
        var dict : [String:Bool] = [:]
        
        if story.userAcceptedStoryID != nil {
            dict = story.userAcceptedStoryID!
        }
        
        if dict[userId] != nil {
            dict[userId] = nil
            DBInteract.store.collection(DBPath.stories.path).document(storyId).updateData(["userAcceptedStoryID" : dict as Any])
            DBInteract.store.collection(DBPath.helpers.path).document(userId).collection(DBPath.acceptedStories.path).document(storyId).delete(completion: { error in
                if error != nil{
                    print(error?.localizedDescription as Any)
                    return
                }
            })
        }else{
            dict[userId] = true
            DBInteract.store.collection(DBPath.stories.path).document(storyId).updateData(["userAcceptedStoryID" : dict as Any])
            do{
                try DBInteract.store.collection(DBPath.helpers.path).document(userId).collection(DBPath.acceptedStories.path).document(storyId).setData(from: story)
            }catch{
                fatalError("something have happened")
            }
        }
    }
    
    func sendImageToDatabase(currentUserId: String ,storyId: String, imageData:[Data], complete: @escaping ([String])->()){
        
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
    
    // MARK: Load Story by ID
    
    func loadStoryById(storyId: String, complete: @escaping (Story)->()){
        
        let ref = DBInteract.store.collection(DBPath.stories.path).document(storyId)
        
        ref.getDocument { snapshot, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            
            do{
                if let story = try snapshot?.data(as: Story.self){
                    complete(story)
                }else{
                    print("problems loading the story")
                }
            }catch let error {
                fatalError(error.localizedDescription)
            }
        }
        
    }
    
}
