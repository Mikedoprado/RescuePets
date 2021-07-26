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

class BaseStoryRepository {
    @Published var stories : [Story] = []
}

protocol RepositoryStoryHelper {
    func load()
    func add(_ story: Story, imageData: [Data])
    func remove(_ story: Story)
    func update(_ story: Story)
}

final class StoryDataRepository: BaseStoryRepository, RepositoryStoryHelper, ObservableObject {

    let pathUser = "users"
    let pathStories = "stories"
    let store = Firestore.firestore()
    let auth = Auth.auth()
    let storage = Storage.storage(url: "gs://rescue-pets-25f38.appspot.com/")
    
    override init(){
        super.init()
        load()
    }
    
    func load(){
        
        guard let currentUserId = auth.currentUser?.uid else {return}
        
        store.collection(pathUser).document(currentUserId).getDocument { [weak self] (snapshotUser, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            let user =  try! snapshotUser?.data(as: User.self)
            guard let userLocation = user?.location else {return}
            let ref = self?.store.collection(self!.pathStories).order(by: "timestamp", descending: true).whereField("location", isEqualTo: userLocation)
            
            ref!.addSnapshotListener { snapshotStories, err in
                if err != nil {
                    print(err?.localizedDescription as Any)
                }
                do {
                    self?.stories =  try snapshotStories?.documents.map({ stories in
                        _ = try stories.data(as: Story.self)
                    }) as! [Story]
                }catch{
                    fatalError("something happen loading stories")
                }
            }
        }
    }
    
    func add(_ story: Story, imageData: [Data]){
        
        guard let currentUserId = auth.currentUser?.uid else {return}
        let storyId = store.collection("stories").document().documentID
        
        do {
            try store.collection(pathStories).document(storyId).setData(from: story)
            let userstories = store.collection(pathUser).document(currentUserId).collection("createdStories").document(storyId)
            userstories.setData(["timestamp":story.timestamp])
            self.sendImageToDatabase(currentUserId: currentUserId, storyId: storyId, imageData: imageData)
            
        }catch{
            fatalError("the story couldn´t be saved")
        }
    }
    
    func remove(_ story: Story) {
        
    }
    
    func update(_ story: Story) {
        
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
