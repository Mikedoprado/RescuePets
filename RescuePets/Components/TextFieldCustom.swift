//
//  TextFieldCustom.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/16/21.
//

import SwiftUI
import UIKit

struct TextFieldCustom: View{
    
    var placeholder : String = ""
    var title : String = ""
    @Binding var kind : String
    @State var activate : Bool = false
    @State var isFocus : Bool = false
    var isSecureField : Bool
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .stroke(ThemeColors.gray.color , lineWidth: 0.5)
                .background(Color.white)
                .frame(height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack (alignment: .leading,spacing: 5){
                HStack {
                    Text(title).modifier(FontModifier(weight: .bold, size: .caption, color: .lightGray))
                    Spacer()
                }
                if !isSecureField {
                    TextField(placeholder, text: $kind) { value in
                        self.activate = value
                    }
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .foregroundColor( ThemeColors.gray.color)
                    
                }else{
                    SecureField(placeholder, text: $kind)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .foregroundColor(ThemeColors.gray.color)
                    
                }
            }.padding(.leading, 20)
            
            
        }
    }
    
}

struct TextFieldCustom_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            TextFieldCustom(placeholder: "Write something", kind: .constant(""), isSecureField: false)
        }.previewLayout(.sizeThatFits)
        
    }
}


