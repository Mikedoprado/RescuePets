//
//  CreateAlertView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/21/21.
//

import SwiftUI
import UIKit

struct CreateAlertView: View {
    
    var imageSelected : Image
    var imageData : Data
    
    @State var text = ""
    @State var showPlaceHolder  = true
    @State var isFocused = false
    @State var animal = ""
    @State var shareInFb = false
    @State var dropDownTitle = "Kind of alert"
    @State var items = ["Adoption", "Desnutrition", "Maltreatment", "Rescue", "Wounded"]
    @State var showKindAlert = false
    @State var kindOfAlert = ""
    
    @Binding var isShowing : Bool
    @Binding var city: String
    @Binding var address: String
    
    @StateObject private var keyboardHandler = KeyboardHandler()
    @StateObject var remaining = RemaininInt(remain: 250)
    
    @ObservedObject var alert = AlertRepository()
    @ObservedObject var currentUser = UserViewModel()
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func createAlert(){
        
        let timestamp = Int(Date().timeIntervalSince1970)
        
        if kindOfAlert != "" && animal != "" && text != ""{
            let alert = Alert(userID: currentUser.userCellViewModel.id, kindOfAlert: TypeOfThreat.init(rawValue: kindOfAlert)!, timestamp: timestamp, animal: KindOfAnimal.init(rawValue: animal)!, image: "", city: city, address: address, description: text, isActive: false)
            
            self.alert.addAlert(alert, imageData: imageData)
        }
    }
    
    func reinitValues(){
        
        self.text = ""
        self.animal = ""
        self.showPlaceHolder = true
        self.kindOfAlert = ""
        self.shareInFb = false
        self.showKindAlert = false
        
    }
    
    var body: some View {
        VStack{
            HStack {
                Text("Create Alert")
                    .modifier(FontModifier(weight: .bold, size: .title, color: .darkGray))
                
                Spacer()
                Button {
                    isShowing = false
                } label: {
                    DesignImage.closeBlack.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25, alignment: .center)
                }
            }
            .background(ThemeColors.white.color)
            .padding(.top, 80)
            .padding(.horizontal, 20)
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack{
                    HStack {
                        PickerAnimal(kindOfAnimal: self.$animal)
                    }
                    .padding(.top, 10)
                    DropDownView(title: $dropDownTitle, items: $items , showOptions: $showKindAlert, kindOfAlert: $kindOfAlert, action: {
                        DispatchQueue.main.async {
                            self.showKindAlert.toggle()
                        }
                    })
                    .padding(.vertical, 10)
                    
                    VStack(spacing: 20){
                        ZStack{
                            imageSelected
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: UIScreen.main.bounds.width - 40)
                                .cornerRadius(10)
                        }
                        
                        TextViewForAlert(text: $text, remainingText: remaining)
                        
                        LocationInfoView(city: $city, address: $address)
                        SwithShare(shareInFb: $shareInFb)
                        
                        NormalButton(textButton: "Publish alert"){
                            self.createAlert()
                            self.isShowing = false
                            self.reinitValues()
                            
                        }
                        .padding(.bottom, 20)
                    }
                    .padding(.bottom, keyboardHandler.keyboardHeight)
                    .animation(.default)
                    Spacer()
                }
                .padding(.horizontal, 30)
            }
            
        }
        .background(ThemeColors.white.color)
        .cornerRadius(20)
        .onTapGesture {
            self.isFocused = false
            self.showKindAlert = false
            self.hideKeyboard()
        }
        .offset(y: self.isShowing ? 0 :  UIScreen.main.bounds.height)
        .animation(.default)
    }
}

struct CreateAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAlertView(imageSelected: Image(""), imageData: Data(), isShowing: .constant(true), city: .constant(""), address: .constant(""))
    }
}

struct TextViewForAlert: View {
    
    @Binding var text : String
    @ObservedObject var remainingText : RemaininInt
    
    var body: some View {
        ZStack {
            TextView(text: $text, remain: remainingText)
                .frame(height: 150)
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    Text("\(remainingText.remain)/250")
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                        .foregroundColor(ThemeColors.halfGray.color)
                }
            }
            .padding(.bottom, 10)
            .padding(.trailing, 10)
            
        }.frame(height: 150)
    }
}



struct SwithShare: View {
    
    @Binding var shareInFb : Bool
    
    var body: some View {
        HStack{
            Toggle("Share in Facebook", isOn: $shareInFb)
                .toggleStyle(SwitchToggleStyle(tint: ThemeColors.redSalsa.color))
            
        }
        .modifier(FontModifier(weight: .bold, size: .paragraph, color: .gray))
    }
}
