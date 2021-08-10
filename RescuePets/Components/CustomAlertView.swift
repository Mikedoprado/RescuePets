//
//  CustomAlertView.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/10/21.
//

import SwiftUI

struct CustomAlertView: View {
 
    var title: String = "Login with your Account"
    @Binding var email: String
    @Binding var password: String
    
    @Binding var showAlert: Bool
    var action: () -> Void
    
    var body: some View {
        
        VStack(spacing: 0){
            Spacer()
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text(title)
                        .modifier(FontModifier(weight: .bold, size: .subtitle, color: .darkGray))
                    Spacer()
                }
                .padding(.top, 20)
                VStack(spacing:0) {
                    TextField("Email Address", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)
                    TextField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                RoundedRectangle(cornerRadius: 0)
                    .frame( height: 1)
                    .foregroundColor(ThemeColors.lightGray.color)
                    .opacity(0.3)
                    .padding(.top, 20)
                
                HStack{
                    Spacer()
                    Button(action: {
                        self.showAlert = false
                    }, label: {
                        Text("Cancel")
                            .fontWeight(.bold)
                    })
                    Spacer()
                    RoundedRectangle(cornerRadius: 0)
                        .frame(width: 1)
                        .foregroundColor(ThemeColors.lightGray.color)
                        .opacity(0.3)
                    Spacer()
                    Button(action: self.action, label: {
                            Text("Login")
                           })
                    Spacer()
                }
                .frame(height: 50)
                
                Spacer()
                
            }
            .frame(height: 190)
            .background(ThemeColors.white.color)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 60)
            Spacer()
        }
        .background(ThemeColors.darkGray.color.opacity(0.8))
        .ignoresSafeArea(edges: .all)
        
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(email: .constant(""), password: .constant(""), showAlert: .constant(true), action: {})
    }
}
