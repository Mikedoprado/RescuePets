//
//  AlertRepository.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/28/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class AlertRepository: ObservableObject {
    
    let db = Firestore.firestore()
    
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
    
    func addAlert(_ alert: Alert) {
        do {
           let _ = try db.collection("alerts").addDocument(from: alert)
        }
        catch{
            fatalError("Unable to encode alert \(error.localizedDescription)")
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
