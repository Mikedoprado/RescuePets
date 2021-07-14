//
//  AlertCellView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/22/21.
//

import SwiftUI

struct AlertCellView: View {
    
    @ObservedObject var alert : AlertCellViewModel
    
    var body: some View {
        HStack {
            Image("pin\(alert.kindOfAnimal)Active" )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            VStack (alignment: .leading){
                Text(alert.kindOfAlert)
                    .modifier(FontModifier(weight: .bold, size: .paragraph, color: .darkGray))
                Text(alert.username)
                    .modifier(FontModifier(weight: .regular, size: .paragraph, color: .lightGray))
                Text(alert.timestamp ?? "")
                    .modifier(FontModifier(weight: .bold, size: .caption, color: .gray))

                }
            Spacer()
            HStack {
                Button{
                    self.alert.alert.isActive.toggle()
                }label: {
                    Image(alert.acceptedAlert)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                
            }
        }
        .padding(.top, 10)
    }
}

struct AlertCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            AlertCellView(alert: AlertCellViewModel(alert: alertList[0]))
        }
        .previewLayout(.sizeThatFits)
    }

}
