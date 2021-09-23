//
//  HelperCellView.swift
//  RescuePets
//
//  Created by Michael do Prado on 9/17/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct HelperCellView: View {
    
    @ObservedObject var userCellViewModel :  UserCellViewModel
    @EnvironmentObject var userViewModel : UserViewModel
//    @Environment(\.redactionReasons) var redactionReasons
    var action: () -> Void
    
    var body: some View {
        HStack {
            AnimatedImage(url: URL(string: userCellViewModel.profileImage))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(ThemeColors.blueCuracao.color)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(userCellViewModel.username.capitalized)
                    .modifier(FontModifier(weight: .bold, size: .paragraph, color: .darkGray))
                Text(userCellViewModel.kindOfUser)
                    .modifier(FontModifier(weight: .regular, size: .paragraph, color: .darkGray))
            }
            Spacer()
            if userCellViewModel.id != userViewModel.userCellViewModel.id {
                Button(action: self.action, label: {
                    DesignImage.message.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .offset(x: 10.0)
                })
            }
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: 50)
        .padding(.horizontal, 20)
    }
}

//struct HelperCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        HelperCellView()
//    }
//}
