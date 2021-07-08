//
//  UserCellViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/3/21.
//

import Foundation
import SwiftUI
import Combine
import Firebase

class UserCellViewModel : ObservableObject, Identifiable {
    
    @Published var user: User
    @Published var userRepository = UserRepository()
    var id : String = ""
    @Published var username: String = ""
    @Published var kindOfUser: TypeOfUser?
    @Published var email: String = ""
    @Published var badges: [Badges]?
    @Published var location: String?
    
    private var cancellables = Set<AnyCancellable>()

    init(user: User) {
        self.user = user
        $user.compactMap{ user in
            user.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
        
        $user.map{ user in
            user.username
        }
        .assign(to: \.username, on: self)
        .store(in: &cancellables)
        
        $user.map{ user in
            user.email
        }
        .assign(to: \.email, on: self)
        .store(in: &cancellables)
        
        $user.map{ user in
            user.location
        }
        .assign(to: \.location, on: self)
        .store(in: &cancellables)
        
        $user.map{ user in
            user.kindOfUser
        }
        .assign(to: \.kindOfUser, on: self)
        .store(in: &cancellables)
        
        $user.map{ user in
            user.badges
        }
        .assign(to: \.badges, on: self)
        .store(in: &cancellables)
        
        $user.sink { user in
            self.userRepository.loadDataCurrentUser()
        }.store(in: &cancellables)
    }
}
