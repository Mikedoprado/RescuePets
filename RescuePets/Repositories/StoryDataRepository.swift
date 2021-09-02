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
    let pathUser = "helpers"
    let pathStories = "stories"
    let pathCreatedStories = "createdStories"
    let pathAcceptedStories = "acceptedStories"
    private let store = Firestore.firestore()
    var auth = AuthenticationModel()
    let storage = Storage.storage(url: "gs://rescue-pets-25f38.appspot.com/")
    private var cancellables: Set<AnyCancellable> = []

    var userRepository = UserRepository()
    private var listenerRegistrationStory: ListenerRegistration?
    private var listenerRegistrationStoryAccepted: ListenerRegistration?
    private var listenerRegistrationStoryCreated: ListenerRegistration?
    var user = User()
    
    init(){

        userRepository.$user.compactMap {  user in
            user
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [weak self] user in
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
        
        listenerRegistrationStory = store
            .collection(self.pathStories)
            .order(by: "timestamp", descending: true)
            .whereField("city", isEqualTo: userLocation)
            .addSnapshotListener { [weak self] snapshotStories, err in
            guard let self = self else {return}
            if err != nil, snapshotStories == nil {
                print(err?.localizedDescription as Any)
            }
            self.stories = snapshotStories!.documents.compactMap({ document in
                    try? document.data(as: Story.self)
            })
        }
    }
    // MARK: load stories created by the currentUser
    func loadCreatedStories(){
        
        if listenerRegistrationStoryCreated != nil {
            listenerRegistrationStoryCreated?.remove()
        }
        
        guard let userID = user.id else {return}
        listenerRegistrationStoryCreated = store
            .collection(pathStories)
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
        listenerRegistrationStoryAccepted = store
            .collection(pathUser)
            .document(userID)
            .collection(pathAcceptedStories)
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
        let storyId = store.collection(pathStories).document().documentID
        
        do {
            try store.collection(pathStories).document(storyId).setData(from: story)
            let helpersStories = store.collection(pathUser).document(userID).collection(pathCreatedStories).document(storyId)
            helpersStories.setData(["timestamp":story.timestamp])
            self.sendImageToDatabase(currentUserId: userID, storyId: storyId, imageData: imageData)
            
        }catch{
            fatalError("the story couldn´t be saved")
        }
    }
    // MARK: deleting story in general and in the user
    func remove(_ story: Story) {
        
        guard let userID = user.id, let storyId = story.id else {return}
        
        store.collection(pathStories).document(storyId).delete { [weak self] error in
            guard let self = self else {return}
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            self.store.collection(self.pathUser).document(userID).collection(self.pathCreatedStories).document(storyId).delete { error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
            }
            
            if story.userAcceptedStoryID != nil {
                self.store.collection(self.pathUser).document(story.userAcceptedStoryID!).collection(self.pathAcceptedStories).document(storyId).delete { error in
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
            if story.userAcceptedStoryID != nil{
                store.collection(pathUser).document(user.id!).collection(pathAcceptedStories).document(story.id!).delete(completion: { [weak self] error in
                    guard let self = self else {return}
                    if error != nil{
                        print(error?.localizedDescription as Any)
                        return
                    }
                    self.store.collection(self.pathStories).document(story.id!).updateData(["isActive":false])
                    self.store.collection(self.pathStories).document(story.id!).updateData(["userAcceptedStoryID":""])
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
    
    // MARK: Load Story by ID
    
    func loadStoryById(storyId: String, complete: @escaping (Story)->()){
        
        let ref = store.collection(pathStories).document(storyId)
        
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
