//
//  AuthenticationModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/30/21.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class AuthenticationModel: ObservableObject {

    private let store = Firestore.firestore()
    let auth = Auth.auth()
    let storage = Storage.storage(url: "gs://rescue-pets-25f38.appspot.com/")
    let pathUser = "helpers"
    let pathProfilePicture = "profilePicture"
    
    var userId: String {
        return isSignedIn ? auth.currentUser!.uid : ""
    }
    
    @Published var signedIn = false
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    var currentUserId : String? {
        return isSignedIn ? auth.currentUser?.uid : nil
    }
    
    func signIn(email: String, password: String, complete: @escaping (String?, Bool)->Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if error != nil {
                complete(error!.localizedDescription, false)
            }
            
            DispatchQueue.main.async {
                self?.signedIn = true
                complete(nil, false)
            }
        }
    }

    func createUser(_ username: String, _ email: String, _ password: String, location: String, imageSelected : ImageSelected, kindOfUser: String){
        
        auth.createUser(withEmail: email, password: password) { [weak self] user, error in
            guard user != nil , error == nil else {return}
            if let userId = user?.user.uid {
                self?.sendProfilePictureToDB(userId: userId, imageData: imageSelected.imageData, complete: { imageUrl in
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
                    
                    self?.store.collection(self!.pathUser).document(userId).setData(dict)
                    
                    DispatchQueue.main.async{
                        self?.signedIn = true
                    }
                })
            }
        }
    }
    
    func sendProfilePictureToDB(userId: String ,imageData: Data, complete: @escaping (String) -> Void) {
        
        let imageProfileId = NSUUID().uuidString
        
        let ref = storage.reference()
        let totalRef = ref.child(userId).child(pathProfilePicture).child(imageProfileId)
        
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
        
        guard let currentUserId = auth.currentUser?.uid else {return}
        let ref = self.store.collection(pathUser).document(currentUserId)
        
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
                    self.store.collection(self.pathUser).document(currentUserId).collection("createdStories").getDocuments { [weak self] snapshot, error in
                        guard let documents = snapshot?.documents else {return}
                        for document in documents{
                            self?.store.collection("stories").document(document.documentID).updateData(["username":username])
                        }
                    }
                    complete(nil, true)
                }
            }
        }
    }
    
    func updateEmail(email: String, complete: @escaping (String?, Bool) -> Void ){
        
        guard let currentUserId = auth.currentUser?.uid else {return}
        let ref = self.store.collection(pathUser).document(currentUserId)
        
        auth.currentUser?.updateEmail(to: email, completion: { error in
            if error != nil {
                complete(error!.localizedDescription as String, false)
            }else{
                ref.updateData(["email": email])
                complete(nil, true)
            }
        })
    }
    
    func updatePassword(userEmail: String, oldPassword: String, newPassword: String, complete: @escaping (String?, Bool) -> Void ) {
        
        auth.signIn(withEmail: userEmail, password: oldPassword) { [weak self] result, err in
            if err != nil {
                complete(err?.localizedDescription, false)
            }else{
                self?.auth.currentUser?.updatePassword(to: newPassword, completion: { error in
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
            try auth.signOut()
            self.signedIn = false
        }catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
