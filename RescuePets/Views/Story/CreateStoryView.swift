////
////  CreatestoryView.swift
////  RescuePets
////
////  Created by Michael do Prado on 6/21/21.
////
//
import SwiftUI
import UIKit
import SDWebImageSwiftUI

struct CreateStoryView: View {
    
    @State var sectionTitle = "Create a Story"
    @State var dropDownTitle = "Kind of story"
    @State var items = ["Adoption", "Malnourished", "Maltreatment", "Rescue", "Wounded"]
    @State var text = ""
    @State var showPlaceHolder  = true
    // switch share in fb
    @State var shareInFb = false
    
    @Binding var inputImage : UIImage?
    @Binding var imageData : Data
    @Binding var showCreateStory : Bool
    @Binding var isShowing : Bool
    @State var isShowPhotoLibrary = false
    
    
    @State var images : [UIImage] = []
    @State var dataImages : [Data] = []
    @State var count : CGFloat = 0
    @State var screen = UIScreen.main.bounds.width
    @State var isFocused = false
    
    // PickerAnimal
    @State var initialValuePickerAnimal = false
    @State var animal = ""
    // Picker kind of story
    @State var initialValueDropDown = false
    @State var animateDropDown = false
    @State var showKindstory = false
    @State var kindOfStory = ""
    
    @ObservedObject var keyboardHandler = KeyboardHandler()
    @ObservedObject var locationManager = LocationManager()
    @EnvironmentObject var userViewModel : UserViewModel
    @ObservedObject var storyViewModel : StoryViewModel
    
    var publishStory : Bool {
        return kindOfStory != "" && text != "" && animal != "" && !dataImages.isEmpty
    }
    
    func loadImage(){

        if let dataImage = inputImage?.jpegData(compressionQuality: 1)  {
            self.images.append(inputImage!)
            self.dataImages.append(dataImage)
            self.isShowPhotoLibrary = false
        }
    }
    
    func dismissView(){
        self.isShowing = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showCreateStory = false
            self.isFocused = false
        }
    }
    
    func reinitValues(){
        self.images.removeAll()
        self.imageData.removeAll()
        self.imageData = Data()
        self.inputImage = nil
        self.text = ""
        self.animal = ""
        self.showPlaceHolder = true
        self.kindOfStory = ""
        self.shareInFb = false
        self.showKindstory = false
        self.initialValuePickerAnimal.toggle()
        self.initialValueDropDown.toggle()
        self.isShowPhotoLibrary = false
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func createStory(){
        self.hideKeyboard()
        let timestamp = Int(Date().timeIntervalSince1970)
        guard
            let kindOfAnimal = KindOfAnimal.init(rawValue: animal),
            let latitude = locationManager.location?.coordinate.latitude,
            let longitude = locationManager.location?.coordinate.longitude
        else {return}
        if kindOfStory != "", text != "", animal != "", !dataImages.isEmpty{
            let newStory = Story(
                username: userViewModel.userCellViewModel.username,
                userId: userViewModel.userCellViewModel.id,
                kindOfStory: kindOfStory,
                timestamp: timestamp,
                animal: kindOfAnimal,
                city: locationManager.city.lowercased(),
                address: locationManager.address,
                description: text,
                latitude: latitude,
                longitude: longitude,
                userAcceptedStoryID: []
            )
            print("saving story")
            self.storyViewModel.add(newStory, imageData: dataImages)
        }
        self.reinitValues()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isShowing = false
        }
    }
    
    
    var body: some View {
        
        VStack{
            
            HeaderView(title: $sectionTitle ,actionDismiss: {
                reinitValues()
                dismissView()
            }, color: .black, alignment: .center)
            
            
            ScrollView(.vertical){
                
                PickerAnimal(kindOfAnimal: self.$animal, initialValue: $initialValuePickerAnimal)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                
                DropDownView(
                    title: $dropDownTitle,
                    items: $items ,
                    showOptions: $showKindstory,
                    kindOfStory: $kindOfStory,
                    initialValue: $initialValueDropDown, animateDropDown: $animateDropDown, action: {
                        withAnimation {
                            self.showKindstory.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.animateDropDown.toggle()
                            }
                        }
                    }) 
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    if images.count > 1 {
                        CarrouselPictures(images: $images)
                    }else{
                        ForEach(images, id: \.self){ image in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: screen - 40 , height: screen - 40 )
                                .background(ThemeColors.whiteGray.color)
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                }
                
                VStack(spacing: 20){
                    if images.count < 4{
                        HStack{
                            Text("Add pictures")
                                .modifier(FontModifier(weight: .bold, size: .paragraph, color: .redSalsa))
                            Spacer()
                            Button(action: {
                                self.inputImage = nil
                                isShowPhotoLibrary = true
                            }, label: {
                                DesignImage.storyAdd.image
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            })
                                .padding(.top, 10)
                        }
                    }
                    
                    TextViewForstory(text: $text)
                    LocationInfoView(city: locationManager.city, address: locationManager.address)
                    SwitchShare(shareInFb: $shareInFb)
                    NormalButton(textButton: "Publish story"){ self.createStory() }
                    .padding(.bottom, 50)
                    .opacity(publishStory ? 1 : 0.8)
                    .disabled(!publishStory)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, keyboardHandler.keyboardHeight)
                Spacer()
            }
            
        }
        .background(ThemeColors.white.color)
        .onAppear(perform: {
            self.isShowPhotoLibrary = true
        })
        .onTapGesture {
            self.hideKeyboard()
        }
        .offset(y: self.isShowing ? 0 :  UIScreen.main.bounds.height)
        .animation(.spring(), value: self.isShowing)
        .sheet(isPresented: $isShowPhotoLibrary, onDismiss: loadImage, content: {
            ImagePicker(selectedImage: $inputImage)
                .ignoresSafeArea(edges: .all)
        })
    }
}

struct SwitchShare: View {
    
    @Binding var shareInFb : Bool
    
    var body: some View {
        HStack{
            Toggle("Share in Facebook", isOn: $shareInFb)
                .toggleStyle(SwitchToggleStyle(tint: ThemeColors.redSalsa.color))
            
        }
        .modifier(FontModifier(weight: .bold, size: .paragraph, color: .gray))
    }
}


