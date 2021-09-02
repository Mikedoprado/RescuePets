//
//  MessageCellViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/18/21.
//

import Combine
import SwiftUI


final class MessageCellViewModel: ObservableObject, Identifiable {
    
    @Published var message : Message
    @Published var storyRepository = StoryDataRepository()
    
    var id : String = ""
    var from: String = ""
    var to: String = ""
    var text: String = ""
    var timestamp: String = ""

    private var cancellables = Set<AnyCancellable>()
    
    init(message: Message) {
        
        self.message = message
        
        $message.compactMap{ message in
            message.id
        }
        .weakAssign(to: \.id, on: self)
        .store(in: &cancellables)
        
        $message.map { message in
            message.from
        }
        .weakAssign(to: \.from, on: self)
        .store(in: &cancellables)
        
        $message.map { message in
            message.to
        }
        .weakAssign(to: \.to, on: self)
        .store(in: &cancellables)
        
        $message.map { message in
            message.text
        }
        .weakAssign(to: \.text, on: self)
        .store(in: &cancellables)
        
        
        $message.compactMap{ [weak self] message in
            self?.storyRepository.setupTimeStamp(time: message.timestamp)
        }
        .weakAssign(to: \.timestamp, on: self)
        .store(in: &cancellables)
        
    }
    
}
