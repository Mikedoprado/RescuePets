//
//  SelectorSection.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/14/21.
//

import SwiftUI

struct SelectorSection: View {
    
    @Binding var categories : [String]
    @Binding var selectedCategory : String
    @Namespace private var animation
    @Binding var color : ThemeColors
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(ThemeColors.white.color)
                .frame(width: (color.color == ThemeColors.redSalsa.color) ? 300 : 200, height: 40)
            
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(color.color)
                .frame(height: 30)
                .padding(.vertical, -5)
                .padding(.horizontal, -20)
                .matchedGeometryEffect(id: selectedCategory, in: animation,isSource: false)
            
            HStack {
                Spacer()
                HStack(alignment: .center, spacing: 0){
                    
                    ForEach(categories, id: \.self) { category in
                        Spacer()
                        VStack {
                            
                            Button(action: {
                                withAnimation (.spring(response: 0.7, dampingFraction: 0.7, blendDuration: 0.5)){
                                    self.selectedCategory = category
                                }
                            }, label: {
                                Text(category)
                                    .multilineTextAlignment(.center)
                                    .modifier(FontModifier(weight: (self.selectedCategory == category) ?  .bold : .regular, size: .paragraph, color: (self.selectedCategory == category) ?  .white : color))
                                    .matchedGeometryEffect(id: category, in: animation, isSource: true)
                            })
                            
                        }
                        Spacer()
                    }
                    
                }
                .padding(.vertical, 10)
                Spacer()
            }
        }
        .frame(width: (color.color == ThemeColors.redSalsa.color) ? 300 : 200, height: 40)
        
    }
}

struct SelectorSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SelectorSection(categories: .constant(["General", "Acepted", "Created"]), selectedCategory: .constant("General"), color: .constant(ThemeColors.redSalsa))
        }.previewLayout(.sizeThatFits)
    }
}
