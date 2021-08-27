//
//  StoryProgress.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/17/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct StoryProgress: View {
    
    @Binding var storyCellViewModel : StoryCellViewModel?
    @Binding var username : String
    @Binding var image : String
    
    var imagestory : String  {
        switch storyCellViewModel?.kindOfAnimal{
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
        switch storyCellViewModel?.kindOfStory {
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
        VStack {
            VStack {
                HStack{
                    Image("pin\(imagestory)Active")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    
                    VStack (alignment: .leading){
                        Text(typeOfThreat)
                            .modifier(FontModifier(weight: .bold, size: .paragraph, color: .redSalsa))
                        
                        HStack {
                            Text(username)
                                .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                            Spacer()
                        }
                    }
                    AnimatedImage(url: URL(string: image))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50,height: 50)
                        .cornerRadius(10)
                        .foregroundColor(ThemeColors.whiteGray.color)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
        .frame(height: 100)
        .background(ThemeColors.white.color)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 20)
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0.0, y: 0.0)
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0.0, y: 0.0)
        
    }
}

//struct StoryProgress_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            StoryProgress()
//        }.previewLayout(.sizeThatFits)
//    }
//}
