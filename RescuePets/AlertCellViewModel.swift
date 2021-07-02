//
//  AlertCellViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/25/21.
//

import Foundation
import SwiftUI
import Combine
import Firebase

class AlertCellViewModel: ObservableObject, Identifiable {
    
    @Published var alert: Alert
    @Published var alertRepository = AlertRepository()
    var id : String = ""
    
    @Published var acceptedAlert = ""
    var kindOfAnimal = ""
    var kindOfAlert = ""
    var username = ""
    @Published var timestamp : String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(alert: Alert){
        self.alert = alert
        
        $alert.map { alert in
            alert.isActive ? "alertAcept" : "alertAdd"
        }
        .assign(to: \.acceptedAlert, on: self)
        .store(in: &cancellables)
        
        $alert.compactMap { alert in
            alert.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
        
        $alert.map{alert in
            alert.animal.animal
        }
        .assign(to: \.kindOfAnimal, on: self)
        .store(in: &cancellables)
        
        $alert.map{alert in
            alert.kindOfAlert.rawValue
        }
        .assign(to: \.kindOfAlert, on: self)
        .store(in: &cancellables)
        
        $alert.map{alert in
            alert.userID
        }
        .assign(to: \.username, on: self)
        .store(in: &cancellables)
        
        $alert.compactMap{alert in
            if let aDate = alert.timestamp?.dateValue() {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let formattedTimeZoneStr = formatter.string(from: aDate)
                    return formattedTimeZoneStr
            }
            return nil
        }
        .assign(to: \.timestamp, on: self)
        .store(in: &cancellables)
        
        $alert
            .sink { alert in
                self.alertRepository.acceptOrRemoveAlert(alert)
            }
            .store(in: &cancellables)
    }
}
