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
    let auth = Auth.auth()
    
    @Published var user : User = User()
    
    init() {
        loadUser()
    }
    
    func loadUser(){
        guard let currentUserId = auth.currentUser?.uid else {return}
        store.collection(path).document(currentUserId).addSnapshotListener{ [weak self] (snapshot, err) in
            if err != nil {
                print("problems loading user",err?.localizedDescription as Any)
                return
            }
            self?.user = try! (snapshot?.data(as: User.self))!
        }
    }
    

    
}
