//
//  UserViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/3/21.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    
    @Published var userRepository = UserRepository()
    @Published var userCellViewModel  = UserCellViewModel(user: User( username: "",email: ""))
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        userRepository.$user.map{ user in
            UserCellViewModel(user: user)
        }
        .assign(to: \.userCellViewModel, on: self)
        .store(in: &cancellables)
    }
    
}
