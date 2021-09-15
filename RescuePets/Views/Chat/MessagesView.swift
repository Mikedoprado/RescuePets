//
//  MessagesView.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/13/21.
//

import SwiftUI

struct MessagesView: View {
    
    @State var sectionTitle =  "Messages"
    @Binding var showMessages : Bool
    @Binding var isAnimating : Bool
    @State var categories = ["New", "Readed"]
    @State var selectedCategory = "New"
    @State var colorMenu = ThemeColors.blueCuracao
    @StateObject var chatViewModel = ChatViewModel()
    @State var showChat = false
    
    @State var userId = ""
    @State var userAcceptedStoryId = ""
    @State var storyId = ""
    @State var chatId = ""
    
    func showChat(chat: Chat){
        guard let chatId = chat.id else {return}
        self.userId = chat.ownerStoryUser
        self.userAcceptedStoryId = chat.acceptedStoryUser
        self.storyId = chat.storyId
        self.chatId = chatId
        self.showChat = true
    }

    var body: some View {
        ZStack {
            VStack {
                VStack{
                    HeaderView(title: $sectionTitle, actionDismiss: {
                        withAnimation {
                            self.isAnimating = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.showMessages = false
                            }
                        }
                    }, color: .white, alignment: .center, closeButtonIsActive: false)
                    .padding(.bottom, 20)
                }
                .background(ThemeColors.blueCuracao.color)
                .animation(.default)
                ScrollView{
                    ForEach(chatViewModel.chatCellViewModels){ chat in
                        Button(action: {
                            self.showChat(chat: chat.chat)
                        }, label: {
                            MessageCellView(chat: chat)
                                .padding(.horizontal, 30)
                        })
                    }
                }
                Spacer()
            }
            .background(ThemeColors.blueCuracao.color)
            .ignoresSafeArea(edges: .all)
            
            if showChat {
                ChatMessagesView(
                    userId: $userId,
                    userAcceptedStoryId: $userAcceptedStoryId,
                    storyId: $storyId,
                    chatViewModel: chatViewModel,
                    showMessages: $showChat,
                    chatId: chatId
                )
            }
            
        }
//        .clipShape(RoundedRectangle(cornerRadius: 20))
//        .offset(y: self.isAnimating ? 0 :  UIScreen.main.bounds.height)
//        .animation(.default)
        .ignoresSafeArea( edges: .all)
        .onAppear{
            print(chatViewModel.chatCellViewModels.forEach{print($0.id)})
        }
    }
}

//struct MessagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessagesView(showMessages: .constant(true), isAnimating: .constant(true), chat: Binding<ChatCellViewModel>)
//    }
//}
