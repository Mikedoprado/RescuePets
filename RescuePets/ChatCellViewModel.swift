//
//  ChatCellViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/24/21.
//

import Combine
import SwiftUI


final class ChatCellViewModel: ObservableObject, Identifiable {
    
    @Published var chat : Chat
    
    var id : String = ""
    var ownerStoryUser: String = ""
    var acceptedStoryUser: String = ""
    var isReaded: Bool = false
    var storyId: String = ""
    var timestamp: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(chat: Chat) {

        self.chat = chat
        
        $chat.compactMap { chat in
            chat.id
        }
        .weakAssign(to: \.id, on: self)
        .store(in: &cancellables)
        
        $chat.map { chat in
            chat.ownerStoryUser
        }
        .weakAssign(to: \.ownerStoryUser, on: self)
        .store(in: &cancellables)
        
        $chat.map { chat in
            chat.acceptedStoryUser
        }
        .weakAssign(to: \.acceptedStoryUser, on: self)
        .store(in: &cancellables)
        
        $chat.map { chat in
            chat.isReaded
        }
        .weakAssign(to: \.isReaded, on: self)
        .store(in: &cancellables)
        
        $chat.map { chat in
            chat.storyId
        }
        .weakAssign(to: \.storyId, on: self)
        .store(in: &cancellables)
        
        $chat.map { chat in
            Timestamp.setupTimeStamp(time: chat.timestamp)
        }
        .weakAssign(to: \.timestamp, on: self)
        .store(in: &cancellables)
        
    }
}
