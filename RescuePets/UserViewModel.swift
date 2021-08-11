//
//  UserViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/23/21.
//

import Combine

final class UserViewModel: ObservableObject {
    
    @Published var userRepository = UserRepository()
    @Published var userCellViewModel : UserCellViewModel = UserCellViewModel(user: User())
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        userRepository.$user.compactMap({ user in
            UserCellViewModel(user: user)
        })
        .weakAssign(to: \.userCellViewModel, on: self)
        .store(in: &cancellables)
    }

}
