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
                }
                .background(ThemeColors.blueCuracao.color)
                
                MessageCellView()
                    .padding(.horizontal, 30)
                Spacer()
            }
            .background(ThemeColors.white.color)
            .ignoresSafeArea(edges: .all)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .offset(y: self.isAnimating ? 0 :  UIScreen.main.bounds.height)
        .animation(.default)
        .ignoresSafeArea( edges: .all)
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(showMessages: .constant(true), isAnimating: .constant(true))
    }
}
