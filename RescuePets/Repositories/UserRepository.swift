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
    
    let path = "helpers"
    private let store = Firestore.firestore()
    private let storage = Storage.storage(url: "gs://rescue-pets-25f38.appspot.com/")
    let auth = AuthenticationModel()
    
    @Published var user : User?
    private var cancelables = Set<AnyCancellable>()
    
    init() {
        loadUser()
    }
    
    func loadUser(){
        guard let currentUserId = auth.currentUserId else {return}
        store.collection(path).document(currentUserId).addSnapshotListener{ [weak self] (snapshot, err) in
            guard let self = self else {return}
            if err != nil {
                print("problems loading user",err?.localizedDescription as Any)
                return
            }
            self.user = try! (snapshot?.data(as: User.self))!
        }
    }
    
    func loadUserById(userID: String, complete: @escaping (User)-> Void){
        store.collection(path).document(userID).getDocument{ (snapshot, err) in
//            guard let self = self else {return}
            if err != nil {
                print("problems loading user",err?.localizedDescription as Any)
                return
            }
            let user = try! (snapshot?.data(as: User.self))!
            complete(user)
        }
    }
    
    func checkUsernameExist(username: String, completion: @escaping (Bool)->())  {
        let ref = store.collection(path).whereField("username", isEqualTo: username)
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
