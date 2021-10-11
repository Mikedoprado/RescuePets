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
    
    private var lastSnapshotStory : QueryDocumentSnapshot?
    private var lastSnapshotStoryAccepted : QueryDocumentSnapshot?
    private var lastSnapshotStoryCreated : QueryDocumentSnapshot?
    
    private var user = User()
    
    enum Stories{
        case general, accepted, created
    }
    
    var kind = Stories.general
    
    var listener : ListenerRegistration? {
        switch kind {
        case .general:
            return listenerRegistrationStory
        case .accepted:
            return listenerRegistrationStoryAccepted
        case .created:
            return listenerRegistrationStoryCreated
        }
    }
    
    var lastSnapshot : QueryDocumentSnapshot? {
        switch kind {
        case .general:
            return lastSnapshotStory
        case .accepted:
            return lastSnapshotStoryAccepted
        case .created:
            return lastSnapshotStoryCreated
        }
    }
    
    init(){
        
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
    
    // MARK: load stories of the one location general stories in your city
    
    func load(){

        self.loadGeneralStories()
        self.loadAcceptedStories()
        self.loadCreatedStories()

    }
    
    //MARK: Load General Stories
    
    func loadGeneralStories(){
        kind = .general
        
        if listener != nil {
            listener?.remove()
        }
        
        guard let userLocation = user.location else {return}
       
        let query : Query
        
        if lastSnapshotStory != nil {
            query = DBInteract.store
                .collection(DBPath.stories.path)
                .order(by: DBPath.timestamp.path, descending: true)
                .whereField(DBPath.city.path, isEqualTo: userLocation)
                .limit(to: 10)
                .start(afterDocument: lastSnapshotStory!)
        }else{
            query = DBInteract.store
                .collection(DBPath.stories.path)
                .order(by: DBPath.timestamp.path, descending: true)
                .whereField(DBPath.city.path, isEqualTo: userLocation)
                .limit(to: 10)
        }

        DBInteract.getData(listener: listener, query: query, lastSnapshot: lastSnapshot) { [weak self] (lastSnapshot, items: [Story]?) in
            guard let stories = items else { return }
            self?.lastSnapshotStory = lastSnapshot
            self?.stories.append(contentsOf: stories)
        }
    }
    
    // MARK: load stories created by the currentUser
    func loadCreatedStories(){
        kind = .created
        if listener != nil {
            listener?.remove()
        }
        
        guard let userID = user.id else {return}
        
        let query = DBInteract.store
            .collection(DBPath.stories.path)
            .order(by: DBPath.timestamp.path, descending: true)
            .whereField(DBPath.userId.path, isEqualTo: userID)
        
        DBInteract.getData(listener: listener, query: query, lastSnapshot: lastSnapshot) { [weak self] (lastSnapshot, items: [Story]?) in
            guard let stories = items else { return }
            self?.lastSnapshotStoryCreated = lastSnapshot
            self?.storiesCreated.append(contentsOf: stories)
        }
    }
    
    // MARK: load stories accepted by the currentUser
    
    func loadAcceptedStories(){
        kind = .accepted
        if listener != nil {
            listener?.remove()
        }
        
        guard let userID = user.id else {return}
        
        let query = DBInteract.store
            .collection(DBPath.stories.path)
            .order(by: DBPath.timestamp.path, descending: true)
            .whereField(DBPath.userAcceptedStoryID.path, arrayContains: userID)
        
        DBInteract.getData(listener: listener, query: query, lastSnapshot: lastSnapshot) { [weak self] (lastSnapshot, items: [Story]?) in
            guard let stories = items else { return }
            self?.lastSnapshotStoryAccepted = lastSnapshot
            self?.storiesAccepted.append(contentsOf: stories)
        }

    }
    
    // MARK: creating a new story
    func add(_ story: Story, imageData: [Data]){
        
        guard let userID = user.id else {return}
        let storyId = DBInteract.store.collection(DBPath.stories.path).document().documentID
        DBInteract.sendImageToDatabase(currentUserId: userID, storyId: storyId, imageData: imageData, complete: { arrayImages in
            do {
                var newStory = story
                newStory.images = arrayImages
                try DBInteract.store.collection(DBPath.stories.path).document(storyId).setData(from: newStory)
                let helpersStories = DBInteract.store.collection(DBPath.helpers.path).document(userID).collection(DBPath.createdStories.path).document(storyId)
                helpersStories.setData([DBPath.timestamp.path:story.timestamp])
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
                dictUser.forEach({ (userId: String) in
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
        
        var dict : [String] = []
        if story.userAcceptedStoryID != nil {
            dict = story.userAcceptedStoryID!
        }
        
        if dict.contains(userId) {
            guard let index = dict.firstIndex(of: userId) else {return}
            dict.remove(at: index)
            DBInteract.store.collection(DBPath.stories.path).document(storyId).updateData([DBPath.userAcceptedStoryID.path : dict as Any])
            
        }else{
            dict.append(userId)
            DBInteract.store.collection(DBPath.stories.path).document(storyId).updateData([DBPath.userAcceptedStoryID.path : dict as Any])
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
    
    deinit{ print("deinit storyRepository")}
    
}
