//
//  StoryHelpersView.swift
//  RescuePets
//
//  Created by Michael do Prado on 9/16/21.
//

import SwiftUI

struct StoryHelpersView: View {
    
    @State var title = "Helpers"
//    @ObservedObject storyCellViewModel : StoryCellViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HeaderView(title: $title, actionDismiss: {
                    
                }, color: .white, alignment: .top, closeButtonIsActive: true)
                .padding(.bottom, 20)
            }
            .background(ThemeColors.redSalsa.color)
            
            HStack {
                Circle()
                    .foregroundColor(ThemeColors.blueCuracao.color)
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading) {
                    Text("Username")
                        .modifier(FontModifier(weight: .bold, size: .paragraph, color: .darkGray))
                    Text("Kind of user")
                        .modifier(FontModifier(weight: .regular, size: .paragraph, color: .darkGray))
                }
                Spacer()
                DesignImage.message.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .offset(x: 10.0)
                    
            }
            .padding(.top, 20)
            .padding(.horizontal, 30)
            Spacer()
        }
        .ignoresSafeArea( edges: .top)
    }
}

struct StoryHelpersView_Previews: PreviewProvider {
    static var previews: some View {
        StoryHelpersView()
    }
}
