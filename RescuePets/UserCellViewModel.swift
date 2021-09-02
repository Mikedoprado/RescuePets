//
//  UserCellViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/23/21.
//

import Combine

final class UserCellViewModel: ObservableObject, Identifiable {
    
//    @Published var userRepository = UserRepository()
    @Published var user : User
    
    var id = ""
    var username : String = ""
    var kindOfUser : String = ""
    var email : String = ""
    var location: String = ""
    var amountStoriesCreated : Int = 0
    var amountStoriesAccepted : Int = 0
    var profileImage : String = ""
    var badges : [Badge] = []
    
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(user: User){
        self.user = user
        
        $user.compactMap { user in
            user.id
        }
        .weakAssign(to: \.id, on: self)
        .store(in: &cancellables)
        
        $user.compactMap { user in
            user.username
        }
        .weakAssign(to: \.username, on: self)
        .store(in: &cancellables)
        
        $user.compactMap { user in
            user.kindOfUser
        }
        .weakAssign(to: \.kindOfUser, on: self)
        .store(in: &cancellables)
        
        $user.compactMap { user in
            user.email
        }
        .weakAssign(to: \.email, on: self)
        .store(in: &cancellables)
        
        $user.compactMap { user in
            user.location
        }
        .weakAssign(to: \.location, on: self)
        .store(in: &cancellables)
        
        $user.compactMap{ user in
            user.amountStoriesCreated
        }
        .weakAssign(to: \.amountStoriesCreated, on: self)
        .store(in: &cancellables)
        
        $user.compactMap{ user in
            user.amountStoriesAccepted
        }
        .weakAssign(to: \.amountStoriesAccepted, on: self)
        .store(in: &cancellables)
        
        $user.compactMap { user in
            user.profileImage
        }
        .weakAssign(to: \.profileImage, on: self)
        .store(in: &cancellables)
        
        $user.compactMap { user in
            user.badges.map { allBadges in
                allBadges.map{ badge in
                    Badge(achievement: badge.achievement, badgeImage: badge.badgeImage, isActive: badge.isActive)
                }
            }
        }
        .weakAssign(to: \.badges, on: self)
        .store(in: &cancellables)
        
    }
    
}
