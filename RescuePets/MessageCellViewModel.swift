//
//  MessageCellViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/25/21.
//

//import Foundation
//import Combine
//
//class MessageCellViewModel: ObservableObject, Identifiable {
//    
//    @Published var message : Message
//    var id = ""
//    var text = ""
//    @Published var timestamp = 0
//    var from = ""
//    var to = ""
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    init(message: Message){
//        self.message = message
//        
//        $message.map{ message in
//            message.id
//        }
//        .assign(to: \.id, on: self)
//        .store(in: &cancellables)
//        
//        $message.map{ message in
//            message.message
//        }
//        .assign(to: \.text, on: self)
//        .store(in: &cancellables)
//        
//        $message.map{ message in
//            message.timestamp
//        }
//        .assign(to: \.timestamp, on: self)
//        .store(in: &cancellables)
//        
//        $message.map{ message in
//            message.from.username
//        }
//        .assign(to: \.from, on: self)
//        .store(in: &cancellables)
//        
//        $message.map{ message in
//            message.to.username
//        }
//        .assign(to: \.to, on: self)
//        .store(in: &cancellables)
//        
//        
//    }
//    
//}
