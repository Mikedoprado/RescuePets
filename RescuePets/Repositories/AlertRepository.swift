//
//  AlertRepository.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/28/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class AlertRepository: ObservableObject {
    
    let db = Firestore.firestore()
    let storage = Storage.storage(url: "gs://rescue-pets-25f38.appspot.com/")
    
    
    @Published var alerts = [Alert]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        db.collection("alerts").order(by: "timestamp").addSnapshotListener { querySnapshot, Error in
            if let querySnapshot = querySnapshot {
                self.alerts = querySnapshot.documents.compactMap { document in
                    try? document.data(as: Alert.self)
                }
            }
        }
    }
    
    func addAlert(_ alert: Alert, imageData: Data) {
        let alertId = db.collection("alerts").document().documentID
        
        do {
            let _ = try db.collection("alerts").document(alertId).setData(from: alert)
            let userAlerts = db.collection("users").document(alert.userID).collection("alerts").document(alertId)
            userAlerts.setData(["timestamp": alert.timestamp as Any])
            sendImageToDatabase(userId: alert.userID, imageData: imageData, alertId: alertId)

        }
        catch{
            fatalError("Unable to encode alert \(error.localizedDescription)")
        }
    }
    
    func sendImageToDatabase(userId: String, imageData: Data, alertId: String){
        let ref = storage.reference()
        let totalRef = ref.child(userId).child("alerts").child(alertId)
        _ = totalRef.putData(imageData, metadata: nil) { _, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            
            totalRef.downloadURL(completion: { [weak self] (url , error) in
                guard let downloadUrl = url?.absoluteString else {return}
                self?.db.collection("alerts").document(alertId).updateData(["image":downloadUrl])
            })
        }
    }
    
    func acceptOrRemoveAlert(_ alert: Alert){
        guard let alertId = alert.id else {return}
        do{
            try db.collection("alerts").document(alertId).setData(from: alert)
        }catch{
            fatalError("Unable to encode alert \(error.localizedDescription)")
        }
    }
}
