//
//  PickerAnimal.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/7/21.
//

import SwiftUI

struct PickerAnimal: View {
    
    @State var selectedIndex = -1
    var animal = ["pinDog", "pinCat", "pinBird", "pinOther"]
    @Binding var kindOfAnimal : String
    @Binding var initialValue : Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Choose the kind of animal")
                .modifier(FontModifier(weight: .regular, size: .subheadline, color: .darkGray))
                .padding(.bottom, 20)
            HStack {
                ForEach(0..<4) { index in
                    if index != 0{
                        Spacer()
                    }
                    Button(action: {
                        self.selectedIndex = index
                        switch index {
                        case 0:
                            self.kindOfAnimal = KindOfAnimal.Dog.animal
                        case 1:
                            self.kindOfAnimal = KindOfAnimal.Cat.animal
                        case 2:
                            self.kindOfAnimal = KindOfAnimal.Bird.animal
                        case 3:
                            self.kindOfAnimal = KindOfAnimal.Other.animal
                        default:
                            break
                        }
                    }, label: {
                        Image((self.selectedIndex == index) ? "\(animal[index])Active" : "\(animal[index])Inactive")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                    })
                    
                }
            }
        }.onChange(of: initialValue, perform: { value in
            self.selectedIndex = -1
        })
    }
}

struct PickerAnimal_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            PickerAnimal(kindOfAnimal: .constant(""), initialValue: .constant(false))
        }
        .previewLayout(.sizeThatFits)
        
    }
}
