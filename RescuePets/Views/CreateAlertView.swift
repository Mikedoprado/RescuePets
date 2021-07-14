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
    var imageMapData: Data
    
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

    @StateObject private var keyboardHandler = KeyboardHandler()
    @StateObject var remaining = RemaininInt(remain: 250)
    
    @ObservedObject var alert = AlertRepository()
    @ObservedObject var currentUser = UserViewModel()
    @ObservedObject private var locationManager = LocationManager()
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func createAlert(){
        
        let timestamp = Int(Date().timeIntervalSince1970)
        
        if kindOfAlert != "" && animal != "" && text != ""{
            let alert = Alert(
                username: currentUser.userCellViewModel.username,
                userId: currentUser.userCellViewModel.id,
                kindOfAlert: TypeOfThreat.init(rawValue: kindOfAlert)!,
                timestamp: timestamp,
                animal: KindOfAnimal.init(rawValue: animal)!,
                city: locationManager.city,
                address: locationManager.address,
                description: text,
                isActive: true
            )
            
            self.alert.addAlert(alert, imageData: imageData, mapImageData: imageMapData)
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
                    self.hideKeyboard()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.isShowing = false
                        self.isFocused = false
                    }
                } label: {
                    DesignImage.closeBlack.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25, alignment: .center)
                }
            }
            .background(ThemeColors.white.color)
            .padding(.top, 50)
            .padding(.horizontal, 20)
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack{
                    HStack {
                        PickerAnimal(kindOfAnimal: self.$animal)
                    }
                    .padding(.top, 10)
                    DropDownView(
                        title: $dropDownTitle,
                        items: $items ,
                        showOptions: $showKindAlert,
                        kindOfAlert: $kindOfAlert,
                        action: {
                            DispatchQueue.main.async {
                                self.showKindAlert.toggle()
                            }
                    })
                    .padding(.vertical, 10)
                    
                    VStack(spacing: 20){
                        imageSelected
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: UIScreen.main.bounds.width - 40)
                            .cornerRadius(10)
                        TextViewForAlert(text: $text, remainingText: remaining)
                        LocationInfoView(city: $locationManager.city, address: $locationManager.address)
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
        CreateAlertView(
            imageSelected: Image(""),
            imageData: Data(), imageMapData: Data(),
            isShowing: .constant(true)
        )
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
