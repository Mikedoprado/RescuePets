//
//  ChatMessagesView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/24/21.
//

import SwiftUI

struct ChatMessagesView: View {
    
    @State var message = ""
//    @ObservedObject var storyCellViewModel : StoryCellViewModel
//    @ObservedObject var storyViewModel : StoryViewModel
    @StateObject private var keyboardHandler = KeyboardHandler()
    @State var isFocused = false
    @State var sectionTitle = "Messages"
    @Binding var showMessages : Bool
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func dismissView(){
        self.showMessages = false
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0){
                VStack {
                    HeaderView(title: $sectionTitle, actionDismiss: {
                        dismissView()
                    }, color: .black, alignment: .center)
                }
                .cornerRadius(20)
                StoryProgress()
            }
            .background(ThemeColors.white.color)
            ScrollView(.vertical, showsIndicators: false){
                ChatCellOwner()
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                ChatCellInvited()
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
            ChatTextField(message: $message)
                .padding(.bottom, keyboardHandler.keyboardHeight)
                .animation(.default)
            
        }
        .background(ThemeColors.white.color)
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            self.isFocused = false
            self.hideKeyboard()
        }
        
    }
}

struct ChatMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessagesView(showMessages: .constant(true))
    }
}




