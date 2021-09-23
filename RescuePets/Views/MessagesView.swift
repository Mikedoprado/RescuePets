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
    @EnvironmentObject var userViewModel : UserViewModel
    @State var showChat = false
    @State var animateChat = false
    @State var chatId = ""
    @State var user = User()
    @Binding var showTabBar : Bool
    @State var isReady = false
    
    func showChat(chat: ChatCellViewModel){
        self.chatId = chat.id
        self.user = chat.user
        self.showChat = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.animateChat = true
            self.showTabBar = false
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                VStack{
                    HeaderView(title: $sectionTitle, actionDismiss: {
                    }, color: .white, alignment: .center, closeButtonIsActive: false)
                    .padding(.bottom, 20)
                }
                .background(ThemeColors.blueCuracao.color)
                
                ScrollView{
                    LazyVStack(spacing:0){
                        ForEach(chatViewModel.chatCellViewModels){ chat in
                            MessageCellView(chat: chat, isActive: $isReady)
                                .padding(.top, 20)
                                .padding(.horizontal, 20)
                                .onTapGesture {
                                    withAnimation {
                                        if isReady {
                                            self.showChat(chat: chat)
                                        }
                                    }
                                }
                        }
                    }
                }
                Spacer()
            }
            .background(ThemeColors.blueCuracao.color)
            .ignoresSafeArea(edges: .all)
            
            if showChat {
                ChatMessagesView(messageViewModel: MessageViewModel(chatId: chatId), showMessages: $showChat, animateChat: $animateChat, chatId: $chatId, user: $user)
            }
            
        }
        .ignoresSafeArea( edges: .all)
        .onChange(of: showChat) { newValue in
            if !showChat{
                self.showTabBar = true
            }
        }
    }
}

//struct MessagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessagesView(showMessages: .constant(true), isAnimating: .constant(true), chat: Binding<ChatCellViewModel>)
//    }
//}
