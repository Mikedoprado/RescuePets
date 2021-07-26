//
//  UserCellViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/23/21.
//

import Combine

final class UserCellViewModel: ObservableObject, Identifiable {
    
    @Published var userRepository = UserRepository()
    @Published var user : User
    
    var id = ""
    @Published var username : String = ""
    @Published var kindOfUser : String = ""
    @Published var email : String = ""
    @Published var location: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(user: User){
        self.user = user
        
        $user.compactMap { user in
            user.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
        
        $user.compactMap { user in
            user.username
        }
        .assign(to: \.username, on: self)
        .store(in: &cancellables)
        
        $user.compactMap { user in
            user.kindOfUser?.rawValue
        }
        .assign(to: \.kindOfUser, on: self)
        .store(in: &cancellables)
        
        $user.compactMap { user in
            user.email
        }
        .assign(to: \.email, on: self)
        .store(in: &cancellables)
        
        $user.compactMap { user in
            user.location
        }
        .assign(to: \.location, on: self)
        .store(in: &cancellables)
    }

}
