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
import FirebaseFirestore

class AlertCellViewModel: ObservableObject, Identifiable {
    
    @Published var alert: Alert
    @Published var alertRepository = AlertRepository()
    @Published var timestamp : String?
    @Published var acceptedAlert = ""
    
    var id : String = ""
    var kindOfAnimal = ""
    var kindOfAlert = ""
    var username = ""
    var userId = ""
    var mapImage = ""
    var city = ""
    var address = ""
    
    
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
            alert.username
        }
        .assign(to: \.username, on: self)
        .store(in: &cancellables)
        
        $alert.map{alert in
            alert.userId
        }
        .assign(to: \.userId, on: self)
        .store(in: &cancellables)
        
        $alert.map{alert in
            alert.city
        }
        .assign(to: \.city, on: self)
        .store(in: &cancellables)
        
        $alert.map{alert in
            alert.address
        }
        .assign(to: \.address, on: self)
        .store(in: &cancellables)
        
        $alert.compactMap{ alert in
            alert.mapImage
        }
        .assign(to: \.mapImage , on: self)
        .store(in: &cancellables)
        
        $alert.compactMap{ [weak self] alert in
            return self?.setupTimeStamp(time: alert.timestamp!)
        }
        .assign(to: \.timestamp, on: self)
        .store(in: &cancellables)
        
        $alert
            .sink { alert in
                self.alertRepository.acceptOrRemoveAlert(alert)
            }
            .store(in: &cancellables)
    }
    
    func setupTimeStamp(time: Int) -> String {

        let timestampDate = Date(timeIntervalSince1970: Double(time))
        let now = Date()
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
        let diff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
        
        var timeText = ""
        
        if diff.second! <= 0 {
            timeText = "Now"
        }
        if diff.second! > 0 && diff.minute! == 0 {
            timeText = (diff.second == 1) ? "\(diff.second!) second ago" : "\(diff.second!) seconds ago"
        }
        if diff.minute! > 0 && diff.hour! == 0 {
            timeText = (diff.second == 1) ? "\(diff.minute!) minute ago" : "\(diff.minute!) minutes ago"
        }
        if diff.hour! > 0 && diff.day! == 0 {
            timeText = (diff.hour == 1) ? "\(diff.hour!) hour ago" : "\(diff.hour!) hours ago"
        }
        if diff.day! > 0 && diff.weekOfMonth! == 0 {
            timeText = (diff.day == 1) ? "\(diff.day!) day ago" : "\(diff.day!) days ago"
        }
        if diff.weekOfMonth! > 0 {
            timeText = (diff.weekOfMonth == 1) ? "\(diff.weekOfMonth!) week ago" : "\(diff.weekOfMonth!) weeks ago"
        }
        
        return timeText
        
    }
    
}
