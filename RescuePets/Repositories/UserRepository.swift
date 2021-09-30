//
//  UserRepository.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/23/21.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class UserRepository: ObservableObject {
    
    @Published var user : User = User()
    @Published var signedIn = false
    
    private var cancelables = Set<AnyCancellable>()
    var isSignedIn: Bool {
        return DBInteract.auth.currentUser != nil
    }
    
    var currentUserId : String? {
        return isSignedIn ? DBInteract.auth.currentUser?.uid : nil
    }
    
    init() {
        
        signedIn = isSignedIn
        
        $signedIn.sink { [weak self] signed in
            if signed{
                self?.loadUser()
            }
        }.store(in: &cancelables)
        
    }
    
    func loadUser(){
        
        guard let currentUserId = DBInteract.auth.currentUser?.uid else {return}
        
        DBInteract.store.collection(DBPath.helpers.path).document(currentUserId).addSnapshotListener{ [weak self] (snapshot, err) in
            guard let self = self else {return}
            if err != nil {
                print("problems loading user",err?.localizedDescription as Any)
                return
            }
            self.user = try! (snapshot?.data(as: User.self))!
        }
    }
    
    func loadUserById(userID: String, complete: @escaping (User)-> Void){
        DBInteract.store.collection(DBPath.helpers.path).document(userID).getDocument{ (snapshot, err) in
            
            if err != nil {
                print("problems loading user",err?.localizedDescription as Any)
                return
            }
            let user = try! (snapshot?.data(as: User.self))!
            complete(user)
        }
    }
    
    func checkUsernameExist(username: String, completion: @escaping (Bool)->())  {
        let ref = DBInteract.store.collection(DBPath.helpers.path).whereField("username", isEqualTo: username)
        ref.getDocuments { snapshot, err in
            if let err = err {
                print("Error getting document: \(err)")
            } else if (snapshot?.isEmpty)! {
                completion(false)
            } else {
                for document in (snapshot?.documents)! {
                    if document.data()["username"] != nil {
                        completion(true)
                    }
                }
            }
        }
    }
}

extension UserRepository {
    // authentication
    func signIn(email: String, password: String, complete: @escaping (String?, Bool)->Void) {
        DBInteract.auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            
            guard let self = self else {return}
            if error != nil {
                complete(error!.localizedDescription, false)
            }else{
                DispatchQueue.main.async {
                    self.signedIn = true
                    complete(nil, false)
                }
            }
        }
        
    }
    
    func createUser(_ username: String, _ email: String, _ password: String, location: String, imageData : Data?, kindOfUser: String){
        
        DBInteract.auth.createUser(withEmail: email, password: password) { [weak self] user, error in
            guard let self = self, user != nil , error == nil else {return}
            if let userId = user?.user.uid {
                guard let data = imageData else {return}
                self.sendProfilePictureToDB(userId: userId, imageData: data, complete: { imageUrl in
                    let dict = [
                        "username": username,
                        "email": email,
                        "location": location,
                        "kindOfUser": kindOfUser,
                        "amountStoriesCreated": 0,
                        "amountStoriesAccepted": 0,
                        "profileImage": imageUrl,
                        "badges": [
                            ["achievement": badgesList[0].achievement, "badgeImage":badgesList[0].badgeImage as Any, "isActive": badgesList[0].isActive],
                            ["achievement": badgesList[1].achievement, "badgeImage":badgesList[1].badgeImage as Any, "isActive": badgesList[1].isActive],
                            ["achievement": badgesList[2].achievement, "badgeImage":badgesList[2].badgeImage as Any, "isActive": badgesList[2].isActive],
                            ["achievement": badgesList[3].achievement, "badgeImage":badgesList[3].badgeImage as Any, "isActive": badgesList[3].isActive],
                            ["achievement": badgesList[4].achievement, "badgeImage":badgesList[4].badgeImage as Any, "isActive": badgesList[4].isActive],
                            ["achievement": badgesList[5].achievement, "badgeImage":badgesList[5].badgeImage as Any, "isActive": badgesList[5].isActive],
                            ["achievement": badgesList[6].achievement, "badgeImage":badgesList[6].badgeImage as Any, "isActive": badgesList[6].isActive],
                            ["achievement": badgesList[7].achievement, "badgeImage":badgesList[7].badgeImage as Any, "isActive": badgesList[7].isActive],
                            ["achievement": badgesList[8].achievement, "badgeImage":badgesList[8].badgeImage as Any, "isActive": badgesList[8].isActive],
                            ["achievement": badgesList[9].achievement, "badgeImage":badgesList[9].badgeImage as Any, "isActive": badgesList[9].isActive],
                            ["achievement": badgesList[10].achievement, "badgeImage":badgesList[10].badgeImage as Any, "isActive": badgesList[10].isActive],
                            ["achievement": badgesList[11].achievement, "badgeImage":badgesList[11].badgeImage as Any, "isActive": badgesList[11].isActive]
                        ]
                    ] as [String : Any]
                    
                    DBInteract.store.collection(DBPath.helpers.path).document(userId).setData(dict)
                    
                    DispatchQueue.main.async{
                        self.signedIn = true
                    }
                })
            }
        }
    }
    
    func sendProfilePictureToDB(userId: String ,imageData: Data, complete: @escaping (String) -> Void) {
        
        let imageProfileId = NSUUID().uuidString
        
        let ref = DBInteract.storage.reference()
        let totalRef = ref.child(userId).child(DBPath.profilePictures.path).child(imageProfileId)
        
        _ = totalRef.putData(imageData, metadata: nil, completion: { _, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            totalRef.downloadURL { url, err in
                guard let downloadUrl = url?.absoluteString else {return}
                complete(downloadUrl)
            }
        })
    }
    
    func updateUserInfo(username: String, kindOfUser: String, imageData: Data?, userViewModel: UserViewModel, complete: @escaping (String?, Bool) -> Void){
        
        guard let currentUserId = DBInteract.auth.currentUser?.uid else {return}
        let ref = DBInteract.store.collection(DBPath.helpers.path).document(currentUserId)
        
        if imageData != nil {
            self.sendProfilePictureToDB(userId: currentUserId, imageData: imageData!) { imageUrl in
                ref.updateData([ "username": username != "" ?  username : userViewModel.userCellViewModel.username,
                                 "kindOfUser": kindOfUser != "" ? kindOfUser : userViewModel.userCellViewModel.kindOfUser,
                                 "profileImage": imageUrl
                ]){ error in
                    if error != nil {
                        complete(error!.localizedDescription as String, false)
                    }else{
                        complete(nil, true)
                    }
                }
            }
        }else {
            ref.updateData([ "username": username != "" ?  username : userViewModel.userCellViewModel.username,
                             "kindOfUser": kindOfUser != "" ? kindOfUser : userViewModel.userCellViewModel.kindOfUser
            ]){ error in
                if error != nil {
                    complete(error!.localizedDescription as String, false)
                }else{
                    DBInteract.store.collection(DBPath.helpers.path).document(currentUserId).collection(DBPath.createdStories.path).getDocuments { snapshot, error in
                        guard let documents = snapshot?.documents else {return}
                        for document in documents{
                            DBInteract.store.collection(DBPath.stories.path).document(document.documentID).updateData(["username":username])
                        }
                    }
                    complete(nil, true)
                }
            }
        }
    }
    
    func updateEmail(email: String, complete: @escaping (String?, Bool) -> Void ){
        
        DBInteract.auth.currentUser?.updateEmail(to: email, completion: { error in
            guard let currentUserId = DBInteract.auth.currentUser?.uid else {return}
            let ref = DBInteract.store.collection(DBPath.helpers.path).document(currentUserId)
            if error != nil {
                complete(error!.localizedDescription as String, false)
            }else{
                ref.updateData(["email": email])
                complete(nil, true)
            }
        })
    }
    
    func updatePassword(userEmail: String, oldPassword: String, newPassword: String, complete: @escaping (String?, Bool) -> Void ) {
        
        DBInteract.auth.signIn(withEmail: userEmail, password: oldPassword) { result, err in
            
            if err != nil {
                complete(err?.localizedDescription, false)
            }else{
                DBInteract.auth.currentUser?.updatePassword(to: newPassword, completion: { error in
                    if error != nil {
                        complete(error?.localizedDescription, false)
                    }else{
                        complete(nil, true)
                    }
                })
            }
        }
    }
    
    func signOut(){
        do {
            try DBInteract.auth.signOut()
            self.signedIn = false
        }catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
