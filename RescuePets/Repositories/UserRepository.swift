//
//  UserRepository.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/3/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class UserRepository: ObservableObject {
    
    let db = Firestore.firestore()
    @Published var user = User(username: "", email: "")
    
    
    init() {
        loadDataCurrentUser()
    }
    
    func loadDataCurrentUser() {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {return}
        db.collection("users").document(userId).addSnapshotListener { snapshot, Error in
            do{
                self.user = (try snapshot?.data(as: User.self))!
            }catch{
                fatalError("jodido \(error.localizedDescription)")
            }
            
        }
    }
}
