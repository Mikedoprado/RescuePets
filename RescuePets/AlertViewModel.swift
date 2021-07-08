//
//  AlertViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/25/21.
//

import Foundation
import Combine

class AlertViewModel: ObservableObject {
    
    @Published var alertRepository = AlertRepository()
    @Published var alertCellViewModels = [AlertCellViewModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        alertRepository.$alerts.map { alerts in
            alerts.map { alert in
                AlertCellViewModel(alert: alert)
            }
        }
        .assign(to: \.alertCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
//    func addAlert(alert: Alert){
//        alertRepository.addAlert(alert)
//    }
}
