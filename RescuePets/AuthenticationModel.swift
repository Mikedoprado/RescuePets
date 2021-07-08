//
//  AuthenticationModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/30/21.
//

import Foundation
import Firebase
import FirebaseFirestore

class AuthenticationModel: ObservableObject {
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    var userId: String {
        return isSignedIn ? auth.currentUser!.uid : ""
    }
    
    @Published var signedIn = false
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil , error == nil else {return}
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func createUser(_ username: String, _ email: String, _ password: String){
        auth.createUser(withEmail: email, password: password) { [weak self] user, error in
            guard user != nil , error == nil else {return}
            if let userId = user?.user.uid {
                let dict = ["username": username, "email": email]
                self?.db.collection("users").document(userId).setData(dict)
            }
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func signOut(){
        try? auth.signOut()
        self.signedIn = false
    }
}
