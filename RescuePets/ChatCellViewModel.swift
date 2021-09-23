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
    var userRepository : UserRepository
    
    var id : String = ""
    var owners : [String] = []
    var isReaded: [String:Bool] = [:]
    var timestamp: String = ""
    var lastMessage: String = ""
    @Published var user : User = User()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(chat: Chat) {
        userRepository = UserRepository()
        self.chat = chat
        
        $chat.compactMap { chat in
            chat.id
        }
        .weakAssign(to: \.id, on: self)
        .store(in: &cancellables)
        
        $chat.map { chat in
            chat.owners
        }
        .weakAssign(to: \.owners, on: self)
        .store(in: &cancellables)
        
        $chat.map { chat in
            chat.isReaded
        }
        .weakAssign(to: \.isReaded, on: self)
        .store(in: &cancellables)
        
        $chat.map { chat in
            Timestamp.setupTimeStamp(time: chat.timestamp)
        }
        .weakAssign(to: \.timestamp, on: self)
        .store(in: &cancellables)
        
        $chat.compactMap { chat in
            chat.lastComment
        }
        .weakAssign(to: \.lastMessage, on: self)
        .store(in: &cancellables)
        
        $chat
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .map { chat in
                Future<User,Never> { promise in
                    let from = ((DBInteract.currentUserId != chat.owners[0]) ? chat.owners[0] : chat.owners[1])
                    self.userRepository.loadUserById(userID: from) { user in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            promise(.success(user))
                        }
                    }
                }
        }
        .switchToLatest()
        .sink { [weak self] user in
                self?.user = user
        }
        .store(in: &cancellables)

    }
}
