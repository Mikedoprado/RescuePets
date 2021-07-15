//
//  ActiveDetailView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/24/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ActiveDetailView: View {
    
    @ObservedObject var alert : AlertCellViewModel
    @Binding var showAlert : Bool
    @Binding var isAnimating : Bool
//    let namespace : Namespace.ID
    
    var imageAlert : String  {
        switch alert.kindOfAnimal{
        case "Dog":
            return KindOfAnimal.Dog.animal
        case "Cat":
            return KindOfAnimal.Cat.animal
        case "Bird":
            return KindOfAnimal.Bird.animal
        case "Other":
            return KindOfAnimal.Other.animal
        default:
            return KindOfAnimal.Other.animal
        }
    }
    
    var typeOfThreat : String {
        switch alert.kindOfAlert {
        case "Rescue":
            return TypeOfThreat.Rescue.rawValue
        case "Adoption":
            return TypeOfThreat.Adoption.rawValue
        case "Wounded":
            return TypeOfThreat.Wounded.rawValue
        case "Maltreatment":
            return TypeOfThreat.Maltreatment.rawValue
        case "Desnutrition":
            return TypeOfThreat.Desnutrition.rawValue
        default:
            return TypeOfThreat.Rescue.rawValue
        }
    }
    
    var body: some View {
        VStack(spacing: 0){
            VStack{
                HStack {
                    Text("Alert")
                        .modifier(FontModifier(weight: .bold, size: .title, color: .darkGray))
                    Spacer()
                    HStack(spacing: 30) {
                        Button {
                            self.alert.alert.isActive.toggle()
                        } label: {
                            Image(alert.acceptedAlert)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                        }
                        Button {
                            
                        } label: {
                            DesignImage.trash.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                        }
                        Button {
                            self.isAnimating = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.showAlert = false
                            }
                        } label: {
                            DesignImage.closeBlack.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 50)
                HStack {
                    Image("pin\(imageAlert)Active")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        
                    
                    VStack (alignment: .leading){
                        Text(alert.kindOfAlert)
                            .modifier(FontModifier(weight: .bold, size: .paragraph, color: .redSalsa))
                        
                        HStack {
                            Text(alert.username)
                                .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                            Spacer()
                        }
                    }
                    Button{
                        
                    }label:{
                        DesignImage.message.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
                .padding(.bottom, 20)
            }
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20){
                    AnimatedImage(url: URL(string:alert.mapImage))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 120)
                        .background(ThemeColors.whiteGray.color)
                        .cornerRadius(20)

                    AnimatedImage(url: URL(string:alert.image))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: UIScreen.main.bounds.width - 100)
                        .background(ThemeColors.whiteGray.color)
                        .cornerRadius(20)

                    Text(alert.description)
                        .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.vertical, 10)
                    LocationInfoView(city: $alert.city, address: $alert.address)
                    .frame(height: 120)
                    .background(ThemeColors.whiteGray.color)
                    .cornerRadius(10)

                }
                .padding(.vertical, 20)
                .padding(.horizontal, 30)
                Spacer()
            }
        }
        .background(ThemeColors.white.color)
        .cornerRadius(20)
        .scaleEffect(self.isAnimating ? 1 :  0)
        .offset(y: self.isAnimating ? 0 :  UIScreen.main.bounds.height)
        .animation(.default)
        
    }
}

struct ActiveDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveDetailView(alert: AlertCellViewModel(alert: alertList[0]), showAlert: .constant(true), isAnimating: .constant(true))
    }
}
