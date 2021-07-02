//
//  CreateAlertView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/21/21.
//

import SwiftUI

struct CreateAlertView: View {
    
    @State var text = ""
    @State var showPlaceHolder  = true
    @State var isFocused = false
    @State var animal : KindOfAnimal = .dog
    @State var isChoosenDog = false
    @State var isChoosenCat = false
    @State var isChoosenBird = false
    @State var isChoosenAnother = false
    @State var shareInFB = false
    
    @StateObject var remaining = RemaininInt(remain: 250)
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack{
                HStack {
                    Text("Create Alert")
                        .modifier(FontModifier(weight: .bold, size: .title, color: .darkGray))
                    Spacer()
                    Button {
                        
                    } label: {
                        DesignImage.closeBlack.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25, alignment: .center)
                    }
                }
                .padding(.top, 50)
                .padding(.horizontal, 30)
                
                
                HStack {
                    VStack(alignment:.leading){
                        Text("Choose the kind of animal")
                            .modifier(FontModifier(weight: .bold, size: .paragraph, color: .blueCuracao))
                            .padding(.bottom, 10)
                        HStack(alignment: .center){
                            Button{
                                self.isChoosenDog = true
                                self.isChoosenCat = false
                                self.isChoosenBird = false
                                self.isChoosenAnother = false
                                self.animal = .dog
                            } label: {
                                PinAnimal(image: !isChoosenDog ?  DesignImage.pinDogInactive.image : DesignImage.pinDogActive.image)
                            }
                            Spacer()
                            Button{
                                self.isChoosenDog = false
                                self.isChoosenCat = true
                                self.isChoosenBird = false
                                self.isChoosenAnother = false
                                self.animal = .cat
                            } label: {
                                PinAnimal(image: !isChoosenCat ?  DesignImage.pinCatInactive.image : DesignImage.pinCatActive.image)
                                    
                            }
                            Spacer()
                            Button{
                                self.isChoosenDog = false
                                self.isChoosenCat = false
                                self.isChoosenBird = true
                                self.isChoosenAnother = false
                                self.animal = .bird
                            } label: {
                                PinAnimal(image: !isChoosenBird ?  DesignImage.pinBirdInactive.image : DesignImage.pinBirdActive.image)
                            }
                            Spacer()
                            Button{
                                self.isChoosenDog = false
                                self.isChoosenCat = false
                                self.isChoosenBird = false
                                self.isChoosenAnother = true
                                self.animal = .other
                            } label: {
                                PinAnimal(image: !isChoosenAnother ?  DesignImage.pinDogInactive.image : DesignImage.pinDogActive.image)
                            }
                        }
                        
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal, 30)
                .onChange(of: animal, perform: { value in
                    print(animal)
                })
                
                HStack{
                    Text("Kind of alert")
                        .modifier(FontModifier(weight: .bold, size: .paragraph, color: .redSalsa))
                    Spacer()
                    Image(systemName: "arrowtriangle.down.fill")
                        .resizable()
                        .frame(width: 15, height: 10, alignment: .center)
                        .foregroundColor(ThemeColors.redSalsa.color)
                        .padding(.trailing, 5)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 30)
                
                VStack(spacing: 20){
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(ThemeColors.lightGray.color)
                            .frame(height: UIScreen.main.bounds.width - 40)
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40 , height: 40)
                            .foregroundColor(ThemeColors.white.color)
                    }
                    .padding(.horizontal, 30)


                    
                    TextViewForAlert(text: text, remainingText: remaining)
                    
                    HStack{
                        Toggle("Share in Facebook", isOn: $shareInFB)
                            .toggleStyle(SwitchToggleStyle(tint: ThemeColors.redSalsa.color))
                            
                    }
                    .modifier(FontModifier(weight: .bold, size: .paragraph, color: .gray))
                    .padding(.horizontal, 30)
                    
                    NormalButton(textButton: "Publish alert"){
                        
                    }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                }
                
                Spacer()
            }
        }
        .background(ThemeColors.white.color)
        .ignoresSafeArea()
        .onTapGesture {
            self.isFocused = false
            self.hideKeyboard()
        }
    }
}

struct CreateAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAlertView()
    }
}

struct TextViewForAlert: View {
    @State var text : String = ""
    @ObservedObject var remainingText : RemaininInt
    var body: some View {
        ZStack {
            TextView(text: $text, remain: remainingText)
                .frame(height: 150)
                .padding(.horizontal, 30)
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
            .padding(.trailing, 40)
            
        }.frame(height: 150)
    }
}

struct PinAnimal: View {
    var image : Image

    var body: some View {

        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60, height: 60, alignment: .center)
        
    }
}
