//
//  StoryHelpersView.swift
//  RescuePets
//
//  Created by Michael do Prado on 9/16/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct StoryHelpersView: View {
    
    @State var title = "Helpers"
    @ObservedObject var storyCellViewModel : StoryCellViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    @State var helpers = [UserCellViewModel]()
    @Binding var showHelpers : Bool
    @Binding var animateHelpers : Bool
    @State var showChat = false
    @State var animateChat = false
    @State var user = User()
    @State var chatId = ""
    @StateObject var chatRepository = ChatRepository()
    
    func showUser(){
        storyCellViewModel.userAcceptedStoryID.forEach { userId in
            userViewModel.userRepository.loadUserById(userID: userId) { user in
                helpers.append(UserCellViewModel(user: user))
            }
        }
    }
    
    func dismissView(){
        self.animateHelpers = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showHelpers = false
        }
    }
    
    func showNewChat(user: User){
        self.user = user
        self.chatRepository.checkChatExist(userId: user.id!) { chatId in
            self.chatId = chatId
            self.showChat = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.animateChat = true
            }
        }
        
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack {
                    HeaderView(title: $title, actionDismiss: {
                        self.dismissView()
                    }, color: .white, alignment: .top, closeButtonIsActive: true)
                    .padding(.bottom, 20)
                }
                .background(ThemeColors.redSalsa.color)
                
                ScrollView(.vertical) {
                    LazyVStack(spacing: 0){
                        ForEach(helpers) { user in
                            HelperCellView(userCellViewModel: user, action: {
                                self.showNewChat(user: user.user)
                            })
                                .padding(.top, 20)
                        }
                    }
                }
                Spacer()
            }
            .ignoresSafeArea( edges: .top)
            .onAppear{
                self.showUser()
            }
            .background(ThemeColors.white.color)
            .offset(y: self.animateHelpers ? 0 : UIScreen.main.bounds.height)
            .animation(.spring(), value: self.animateHelpers)
            
            
            if showChat{
                ChatMessagesView(messageViewModel: MessageViewModel(chatId: chatId), showMessages: $showChat, animateChat: $animateChat, chatId: $chatId, user: $user)
            }
            
        }
    }
}

//struct StoryHelpersView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoryHelpersView()
//    }
//}


