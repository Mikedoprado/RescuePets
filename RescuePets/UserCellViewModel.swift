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
    @Published var location: String = ""
    @Published var amountStoriesCreated : Int = 0
    @Published var amountStoriesAccepted : Int = 0
    @Published var profileImage : String = ""
    @Published var badges : [Badge] = []
    
    
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
            user.kindOfUser
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
        
        $user.compactMap{ user in
            user.amountStoriesCreated
        }
        .assign(to: \.amountStoriesCreated, on: self)
        .store(in: &cancellables)
        
        $user.compactMap{ user in
            user.amountStoriesAccepted
        }
        .assign(to: \.amountStoriesAccepted, on: self)
        .store(in: &cancellables)
        
        $user.compactMap { user in
            user.profileImage
        }
        .assign(to: \.profileImage, on: self)
        .store(in: &cancellables)
        
        $user.compactMap { user in
            user.badges.map { allBadges in
                allBadges.map{ badge in
                    Badge(achievement: badge.achievement, badgeImage: badge.badgeImage, isActive: badge.isActive)
                }
            }
        }
        .assign(to: \.badges, on: self)
        .store(in: &cancellables)
        
    }
    
}
