//
//  MessagesView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/24/21.
//

import SwiftUI

struct MessagesView: View {
    
    @State var message = ""
    @StateObject private var keyboardHandler = KeyboardHandler()
    @State var isFocused = false
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Messages")
                        .modifier(FontModifier(weight: .bold, size: .title, color: .darkGray))
                    Spacer()
                    Button {
                        
                    } label: {
                        DesignImage.closeBlack.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25, alignment: .center)
                    }
                }
                .padding(.vertical, 25)
                ChatCellOwner()
                Spacer()
            }
            .padding(.horizontal, 30)
            .background(ThemeColors.white.color)
            .cornerRadius(20)
            
            HStack{
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(ThemeColors.white.color)
                    TextField("Write your message", text: $message)
                        .foregroundColor(ThemeColors.darkGray.color)
                        .padding(.leading, 20)
                }
                .padding(.leading, 20)
                
                Button{
                    
                }label: {
                    DesignImage.send.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                }
                Spacer()
            }
            .frame(height: 50)
            .padding(.all, 10)
            .background(ThemeColors.blueCuracao.color)
            .padding(.bottom, keyboardHandler.keyboardHeight)
            .animation(.default)
        }
        .edgesIgnoringSafeArea(.bottom)
        .onTapGesture {
            self.isFocused = false
            self.hideKeyboard()
        }
        
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
