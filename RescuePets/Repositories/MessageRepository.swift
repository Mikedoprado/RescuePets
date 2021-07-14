//
//  MessageRepository.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/29/21.
//

//import Foundation
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//
//class MessageRepository: ObservableObject {
//    
//    let db = Firestore.firestore()
//    
//    @Published var messages = [Message]()
//    
//    init() {
//        loadData()
//    }
//    
//    func loadData() {
//        db.collection("messages").order(by: "timestamp").addSnapshotListener { querySnapshot, Error in
//            if let querySnapshot = querySnapshot {
//                self.messages = querySnapshot.documents.compactMap { document in
//                    try? document.data(as: Message.self)
//                }
//            }
//        }
//    }
//    
//    func addMessage(_ message: Message) {
//        do {
//           let _ = try db.collection("messages").addDocument(from: message)
//        }
//        catch{
//            fatalError("Unable to encode alert \(error.localizedDescription)")
//        }
//    }
//    
//}
