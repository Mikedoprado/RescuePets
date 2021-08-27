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
    @ObservedObject var chatViewModel = ChatViewModel()
    @State var showChat = false
    
    @State var userId = ""
    @State var userAcceptedStoryId = ""
    @State var storyId = ""
    @State var chatId = ""
    
    func showChat(chat: Chat){
        self.userId = chat.ownerStoryUser
        self.userAcceptedStoryId = chat.acceptedStoryUser
        self.storyId = chat.storyId
        self.chatId = chat.id!
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
                    }, color: .white, alignment: .center)
                    .padding(.bottom, 30)
                    SelectorSection(categories: $categories, selectedCategory: $selectedCategory, color: $colorMenu)
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
            .background(ThemeColors.white.color)
            .ignoresSafeArea(edges: .all)
            
            if showChat {
                ChatMessagesView(
                    userId: $userId,
                    userAcceptedStoryId: $userAcceptedStoryId,
                    storyId: $storyId,
                    messageViewModel: MessageViewModel(chatId: chatId),
                    chatViewModel: chatViewModel,
                    showMessages: $showChat,
                    chatId: $chatId
                )
            }
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .offset(y: self.isAnimating ? 0 :  UIScreen.main.bounds.height)
        .animation(.default)
        .ignoresSafeArea( edges: .all)
    }
}

//struct MessagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessagesView(showMessages: .constant(true), isAnimating: .constant(true), chat: Binding<ChatCellViewModel>)
//    }
//}
