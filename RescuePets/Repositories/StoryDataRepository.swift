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
    func add(_ story: Story)
    func remove(_ story: Story)
    func update(_ storyCellViewModel: StoryCellViewModel)
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
        
        if listenerRegistrationStory != nil {
            listenerRegistrationStory?.remove()
        }
        
        guard let userLocation = user.location else {return}
        
        let query = DBInteract.store
                .collection(DBPath.stories.path)
                .order(by: DBPath.timestamp.path, descending: true)
                .whereField(DBPath.city.path, isEqualTo: userLocation)
//                .limit(to: 10)

        DBInteract.getData(listener: listenerRegistrationStory, query: query, lastSnapshot: lastSnapshotStory) { [weak self] (lastSnapshot, items: [Story]?) in
            guard let stories = items else { return }
            self?.stories = stories
            self?.lastSnapshotStory = lastSnapshot
        }
    }
    
    func fetchPagination(){
        
        if listenerRegistrationStory != nil {
            listenerRegistrationStory?.remove()
        }
        
        guard let userLocation = user.location else {return}
        
        let query = DBInteract.store
            .collection(DBPath.stories.path)
            .order(by: DBPath.timestamp.path, descending: true)
            .whereField(DBPath.city.path, isEqualTo: userLocation)
            .start(afterDocument: lastSnapshotStory!)
            .limit(to: 10)
        
        DBInteract.getData(listener: listenerRegistrationStory, query: query, lastSnapshot: lastSnapshotStory) { [weak self] (lastSnapshot, items: [Story]?) in
            guard let stories = items else { return }
            self?.stories.append(contentsOf: stories)
            self?.lastSnapshotStory = lastSnapshot
        }

    }
    
    // MARK: load stories created by the currentUser
    func loadCreatedStories(){
        
        if listenerRegistrationStoryCreated != nil {
            listenerRegistrationStoryCreated?.remove()
        }
        
        guard let userID = user.id else {return}
        
        let query = DBInteract.store
            .collection(DBPath.stories.path)
            .order(by: DBPath.timestamp.path, descending: true)
            .whereField(DBPath.userId.path, isEqualTo: userID)
        
        DBInteract.getData(listener: listenerRegistrationStoryCreated, query: query, lastSnapshot: lastSnapshotStoryCreated) { [weak self] (lastSnapshot, items: [Story]?) in
            guard let stories = items else { return }
            self?.storiesCreated = stories
            self?.lastSnapshotStoryCreated = lastSnapshot
        }
    }
    
    // MARK: load stories accepted by the currentUser
    
    func loadAcceptedStories(){
        
        if listenerRegistrationStoryAccepted != nil {
            listenerRegistrationStoryAccepted?.remove()
        }
        
        guard let userID = user.id else {return}
        
        let query = DBInteract.store
            .collection(DBPath.stories.path)
            .order(by: DBPath.timestamp.path, descending: true)
            .whereField(DBPath.userAcceptedStoryID.path, arrayContains: userID)
        
        DBInteract.getData(listener: listenerRegistrationStoryAccepted, query: query, lastSnapshot: lastSnapshotStoryAccepted) { [weak self] (lastSnapshot, items: [Story]?) in
            guard let stories = items else { return }
            self?.storiesAccepted = stories
            self?.lastSnapshotStoryAccepted = lastSnapshot
        }

    }
    
    // MARK: creating a new story
    func add(_ story: Story){
        
        guard let userID = user.id, let imageData = story.imageData else {return}
        let storyId = DBInteract.store.collection(DBPath.stories.path).document().documentID
        DBInteract.sendImageToDatabase(currentUserId: userID, storyId: storyId, imageData: imageData, complete: { arrayImages in
            do {
                var newStory = story
                newStory.images = arrayImages
                newStory.imageData = nil
                try DBInteract.store.collection(DBPath.stories.path).document(storyId).setData(from: newStory)
                let helpersStories = DBInteract.store.collection(DBPath.helpers.path).document(userID).collection(DBPath.createdStories.path).document(storyId)
                helpersStories.setData([DBPath.timestamp.path : story.timestamp])
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
            
            if !story.userAcceptedStoryID.isEmpty {
                let dictUser = story.userAcceptedStoryID
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
    
    func update(_ storyCellViewModel: StoryCellViewModel){
        
        guard let userId = DBInteract.currentUserId else {return}
        let storyId = storyCellViewModel.id
        switch storyCellViewModel.acceptedStory{
        case true:
            
            storyCellViewModel.userAcceptedStoryID.append(userId)
            
            DBInteract.store.collection(DBPath.stories.path).document(storyId).updateData([DBPath.userAcceptedStoryID.path : storyCellViewModel.userAcceptedStoryID as Any])
        case false:
           
            for (index, id) in storyCellViewModel.userAcceptedStoryID.enumerated() {
                if id == userId {
                    storyCellViewModel.userAcceptedStoryID.remove(at: index)
                }
            }
            
            DBInteract.store.collection(DBPath.stories.path).document(storyId).updateData([DBPath.userAcceptedStoryID.path : storyCellViewModel.userAcceptedStoryID as Any])
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
