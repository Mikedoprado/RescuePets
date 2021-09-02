//
//  ChatMessagesView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/24/21.
//

import SwiftUI

struct ChatMessagesView: View {
    
    @State var message = ""
    @Binding var userId : String
    @Binding var userAcceptedStoryId : String
    @Binding var storyId : String
    @StateObject private var keyboardHandler = KeyboardHandler()
    @EnvironmentObject var auth : AuthenticationModel
    @StateObject var messageViewModel : MessageViewModel
    @StateObject var userRepository = UserRepository()
    @StateObject var chatViewModel : ChatViewModel
    @State var isFocused = false
    @State var sectionTitle = "Messages"
    @Binding var showMessages : Bool
    @StateObject var storyRepository = StoryDataRepository()
    @Binding var chatId : String
    
    @State var currentUsername = ""
    @State var currentProfileImage = ""
    @State var othertUsername = ""
    @State var otherProfileImage = ""
    @State var storyCellViewModel : StoryCellViewModel?
    @State var username = ""
    @State var image = ""

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0){
                VStack {
                    HeaderView(title: $sectionTitle, actionDismiss: {
                        dismissView()
                    }, color: .black, alignment: .center)
                }
                .cornerRadius(20)
                .padding(.bottom, 10)
                StoryProgress(storyCellViewModel: $storyCellViewModel, username: $username, image: $image)
            }
            .background(ThemeColors.white.color)
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(spacing: 20){
                    ForEach(messageViewModel.messagesViewModels){ message in
                        if message.from == auth.currentUserId{
                            ChatCellOwner(text: message.text, username: currentUsername, profileImage: currentProfileImage)
                                .padding(.horizontal, 30)
                        }else{
                            ChatCellInvited(text: message.text, username: othertUsername, profileImage: otherProfileImage)
                                .padding(.horizontal, 30)
                        }
                    }
                }
                .padding(.bottom, 20)
                
            }
            ChatTextField(message: $message, action: {
                self.addMessage()
                self.message =  ""
            })
                .padding(.bottom, keyboardHandler.keyboardHeight)
                .animation(.default)
            
        }
        .background(ThemeColors.white.color)
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            self.isFocused = false
            self.hideKeyboard()
        }
        .onAppear{
            self.username(userId: userId)
            self.username(userId: userAcceptedStoryId)
            self.loadStory()
        }

    }
    
    //MARK: functions
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func dismissView(){
        if messageViewModel.messagesViewModels.count == 0 {
            chatViewModel.remove(chatId, acceptedStoryUser: userAcceptedStoryId, ownerStoryUser: userId)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showMessages = false
        }
    }
    
    func username(userId: String) {
        if userId == auth.currentUserId {
            showUserName(userId: userId) {  user in
                self.currentUsername = user.username!
                self.currentProfileImage = user.profileImage!
            }
        }else{
            showUserName(userId: userId) {  user in
                self.othertUsername = user.username!
                self.otherProfileImage = user.profileImage!
            }
        }
    }
    
    func showUserName(userId: String, complete: @escaping (User)-> ()){
        userRepository.loadUserById(userID: userId) { user in
           complete(user)
        }
    }
    
    func loadStory(){
        storyRepository.loadStoryById(storyId: storyId) { story in
            self.storyCellViewModel = StoryCellViewModel(story: story)
            self.username = story.username
            self.image = story.images![0]
        }
    }

    func addMessage(){
        if message != ""{
            let timestamp = Int(Date().timeIntervalSince1970)
            guard let currentUserID = auth.currentUserId else {return}
            let to = currentUserID != userId ? userId : userAcceptedStoryId
            let newMessage = Message(from: currentUserID, to: to, text: message, timestamp: timestamp)
            
            messageViewModel.add(newMessage, chatId: chatId, from: currentUserID, to: to)
        }
    }
}

//struct ChatMessagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatMessagesView(userId: .constant(""), userAcceptedStoryId: .constant(""), storyId: .constant(""), chatViewModel: ChatViewModel(), chatCellViewModel: ChatCellViewModel(chat: Chat()), showMessages: .constant(true), chatId: .constant(""))
//    }
//}




