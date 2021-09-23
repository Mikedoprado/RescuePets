//
//  CommentView.swift
//  RescuePets
//
//  Created by Michael do Prado on 9/9/21.
//

import SwiftUI

struct CommentView: View {
    
    @Binding var showMessage : Bool
    @Binding var animShowMessage: Bool
    @EnvironmentObject var userViewModel : UserViewModel
    @StateObject private var keyboardHandler = KeyboardHandler()
    @StateObject var commentViewModel = CommentViewModel(storyId: "")
    @State var message = ""
    @State var sectionTitle = "Comments"
    var storyId = ""
    
    func dismissView(){
        withAnimation {
            self.animShowMessage = false
            self.hideKeyboard()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showMessage = false
            }
        }
        
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func addComment(){
        if message != "" {
            let timestamp = Int(Date().timeIntervalSince1970)
            let newComment = Comment(from: userViewModel.userCellViewModel.id, text: message, timestamp: timestamp)
            commentViewModel.add(newComment, storyId: self.storyId)
            self.message =  ""
        }
    }
    
    var body: some View {
        
        VStack {
            VStack {
                HeaderView(title: $sectionTitle, actionDismiss: {
                    dismissView()
                }, color: .white, alignment: .center)
                .padding(.bottom, 20)
                
            }
            .background(ThemeColors.redSalsa.color)
            ScrollView{
                LazyVStack(alignment: .leading){
                    ForEach(commentViewModel.commentsCellViewModel){ comment in
                        CommentCellView(commentCellViewModel: comment)
                            .padding(.top, 10)
                    }
                    
                }
            }
            Spacer()
            ChatTextField(message: $message, action: {
                self.addComment()
            })
            .padding(.bottom, keyboardHandler.keyboardHeight)
        }
        .background(ThemeColors.white.color)
        .ignoresSafeArea(edges: .vertical)
        .offset(y: self.animShowMessage ? 0 :  UIScreen.main.bounds.height)
        .animation(.spring(), value: self.animShowMessage)
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(showMessage: .constant(true), animShowMessage: .constant(true))
    }
}
