//
//  ChatMessagesView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/24/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatMessagesView: View {
    
    @State var message = ""
    @ObservedObject var keyboardHandler = KeyboardHandler()
    @EnvironmentObject var userViewModel : UserViewModel
    @StateObject var messageViewModel = MessageViewModel()
    @State var sectionTitle = "Messages"
    @Binding var showMessages : Bool
    @Binding var animateChat: Bool
    @Binding var chatId : String
 
    @Binding var user: User
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0){
                VStack {
                    HStack{
                        AnimatedImage(url: URL(string: user.profileImage!))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .foregroundColor(ThemeColors.blueCuracao.color)
                            .clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text(user.username!.capitalized)
                                .modifier(FontModifier(weight: .regular, size: .paragraph, color: .white))
                            Text(user.kindOfUser!)
                                .modifier(FontModifier(weight: .bold, size: .caption, color: .white))
                        }
                        Spacer()
                        Button(action: {
                            self.dismissView()
                        }, label: {
                            DesignImage.closeWhite.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                        })
                    }
                }
                .padding(.top, 50)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            }
            .background(ThemeColors.redSalsa.color)
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(spacing: 0){
                    
                        ForEach(messageViewModel.messagesViewModels){ message in
                            if message.from == userViewModel.userCellViewModel.id {
                                ChatCellOwner(text: message.text, username: userViewModel.userCellViewModel.username, profileImage: userViewModel.userCellViewModel.profileImage)
                                    .padding(.horizontal, 20)
                                    .padding(.top, 10)
                            }else{
                                ChatCellInvited(text: message.text, username: user.username!, profileImage: user.profileImage!)
                                    .padding(.horizontal, 20)
                                    .padding(.top, 10)
                            }
                        }
                    
                }
                .padding(.bottom, 20)
                
            }
            ChatTextField(message: $message, action: {
                withAnimation {
                    self.addMessage()
                    self.message =  ""
                }
            })
                .padding(.bottom, keyboardHandler.keyboardHeight)
                .animation(.spring(), value: keyboardHandler.keyboardHeight)
            
        }
        .background(ThemeColors.white.color)
        .edgesIgnoringSafeArea(.all)
        .offset(y: self.animateChat ? 0 : UIScreen.main.bounds.height)
        .animation(.spring(), value: self.animateChat)
        .onTapGesture {
            self.hideKeyboard()
        }
        .onAppear {
            if self.chatId != ""{
                self.messageViewModel.chatId = chatId
            }
        }
    }
}

extension ChatMessagesView {
    //MARK: functions
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func dismissView(){
        withAnimation {
            self.hideKeyboard()
            self.animateChat = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showMessages = false
            }
        }
    }

    func addMessage(){
        let timestamp = Int(Date().timeIntervalSince1970)
        if let userId = user.id {
            let newMessage = Message( from: userViewModel.userCellViewModel.id, to: userId, text: message, timestamp: timestamp)
            self.messageViewModel.add(newMessage, chatId: chatId, complete: { id in
                self.chatId = id
            })
        }
    }
}

//struct ChatMessagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatMessagesView(userId: .constant(""), showMessages: .constant(true), animateChat: .constant(true))
//    }
//}




