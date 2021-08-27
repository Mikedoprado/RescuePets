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
    @Published var timestamp: String = ""
    @Published var chatRepository = ChatRepository()
    @Published var storyRepository = StoryDataRepository()
    
    var id : String = ""
    var ownerStoryUser: String = ""
    var acceptedStoryUser: String = ""
    var isReaded: Bool = false
    var storyId: String = ""

    private var cancellables = Set<AnyCancellable>()
    
    init(chat: Chat) {
        
        self.chat = chat
        
        $chat.compactMap { chat in
            chat.id
        }
        .weakAssign(to: \.id, on: self)
        .store(in: &cancellables)
        
        $chat.compactMap { chat in
            chat.ownerStoryUser
        }
        .weakAssign(to: \.ownerStoryUser, on: self)
        .store(in: &cancellables)
        
        $chat.compactMap { chat in
            chat.acceptedStoryUser
        }
        .weakAssign(to: \.acceptedStoryUser, on: self)
        .store(in: &cancellables)
        
        $chat.compactMap { chat in
            chat.isReaded
        }
        .weakAssign(to: \.isReaded, on: self)
        .store(in: &cancellables)
        
        $chat.compactMap { chat in
            chat.storyId
        }
        .weakAssign(to: \.storyId, on: self)
        .store(in: &cancellables)
        
        $chat.compactMap { chat in
            self.storyRepository.setupTimeStamp(time: chat.timestamp)
        }
        .weakAssign(to: \.timestamp, on: self)
        .store(in: &cancellables)
        
    }
}