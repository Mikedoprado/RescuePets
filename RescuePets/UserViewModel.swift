//
//  UserViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/23/21.
//

import Combine
import Foundation

final class UserViewModel: ObservableObject {
    
    var userRepository = UserRepository()
    @Published var userCellViewModel : UserCellViewModel = UserCellViewModel(user: User())
    @Published var isSigned : Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        userRepository.$signedIn
            .sink(receiveValue: { [weak self] value in
            self?.isSigned = value
        })
        .store(in: &cancellables)
        
        $isSigned
            .sink(receiveValue: { [weak self] value in
            
            if value{
                self?.userRepository.$user.compactMap { user in
                    UserCellViewModel(user: user)
                }
                .weakAssign(to: \.userCellViewModel, on: self!)
                .store(in: &self!.cancellables)
            }
        })
        .store(in: &cancellables)
    }
    
    func signIn(email: String, password: String, complete: @escaping (String?, Bool)->Void) {
        self.userRepository.signIn(email: email, password: password, complete: complete)
    }
    func createUser(_ username: String, _ email: String, _ password: String, location: String, imageData : Data, kindOfUser: String){
        self.userRepository.createUser(username, email, password, location: location, imageData: imageData, kindOfUser: kindOfUser)
    }
    
    func updateEmail(email: String, complete: @escaping (String?, Bool) -> Void ){
        self.userRepository.updateEmail(email: email, complete: complete)
    }
    
    func updateUserInfo(username: String, kindOfUser: String, imageData: Data?, userViewModel: UserViewModel, complete: @escaping(String?, Bool)-> Void){
        self.userRepository.updateUserInfo(username: username, kindOfUser: kindOfUser, imageData: imageData, userViewModel: userViewModel, complete: complete)
    }
    
    func updatePassword(userEmail: String, oldPassword: String, newPassword: String, complete: @escaping (String?, Bool) -> Void ) {
        self.userRepository.updatePassword(userEmail: userEmail, oldPassword: oldPassword, newPassword: newPassword, complete: complete)
    }
    
    func signOut(){
        self.userRepository.signOut()
    }
    
    deinit{
        print("deinit UserViewModel")
    }

}
