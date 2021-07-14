//
//  MessageViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/25/21.
//

//import Foundation
//import Combine
//
//
//class MessageViewModel: ObservableObject {
//    
//    @Published var messageCellVM = [MessageCellViewModel]()
//    @Published var messageRepository = MessageRepository()
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    init() {
////        messageRepository.$messages.map{ messages in
////            messages.map { message in
////                MessageCellViewModel(message: message)
////            }
////        }
////        .assign(to: \.messageCellVM, on: self)
////        .store(in: &cancellables)
//        
//        self.messageCellVM = messages.map{message in
//            MessageCellViewModel(message: message)
//        }
//    }
//    
//    func addMessage(message: Message){
//        messageRepository.addMessage(message)
//    }
//}
