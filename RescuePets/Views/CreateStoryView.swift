//
//  CreatestoryView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/21/21.
//

import SwiftUI
import UIKit

struct CreateStoryView: View {
    
    @Binding var imageSelected : ImageSelected
    
    @State var images : [ImageSelected] = []
    
    @State var text = ""
    @State var showPlaceHolder  = true
    @State var isFocused = false
    @State var animal = ""
    @State var shareInFb = false
    @State var dropDownTitle = "Kind of story"
    @State var items = ["Adoption", "Malnourished", "Maltreatment", "Rescue", "Wounded"]
    @State var showKindstory = false
    @State var kindOfStory = ""
    @State var initialValuePickerAnimal = false
    @State var initialValueDropDown = false
    @State var isShowPhotoLibrary = false
    @Binding var isShowing : Bool
    @State private var inputImage: UIImage?
    
    @StateObject private var keyboardHandler = KeyboardHandler()
    @StateObject var remaining = RemaininInt(remain: 250)
    
    @ObservedObject private var locationManager = LocationManager()
    @ObservedObject private var storyViewModel = StoryViewModel()
    @ObservedObject private var userViewModel = UserViewModel()
    
    @State var x : CGFloat = 0
    @State var count : CGFloat = 0
    @State var screen = UIScreen.main.bounds.width
    @State var op : CGFloat = 0
    @State var dataCount : Int = 0
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func createstory(){
        
        let timestamp = Int(Date().timeIntervalSince1970)
        let images = images.map{$0.imageData}
        
        if kindOfStory != "" && animal != "" && text != "" {
            let story = Story(
                username: userViewModel.userCellViewModel.username,
                userId: userViewModel.userCellViewModel.id,
                kindOfStory: kindOfStory,
                timestamp: timestamp,
                animal: KindOfAnimal.init(rawValue: animal)!,
                city: locationManager.city.lowercased(),
                address: locationManager.address,
                description: text,
                isActive: false,
                latitude: (locationManager.location?.coordinate.latitude)!,
                longitude:(locationManager.location?.coordinate.longitude)!,
                userAcceptedStoryID: "")
            
            self.storyViewModel.add(story, imageData: images)
            
        }
    }
    
    func reinitValues(){
        self.text = ""
        self.animal = ""
        self.showPlaceHolder = true
        self.kindOfStory = ""
        self.shareInFb = false
        self.showKindstory = false
        self.initialValuePickerAnimal.toggle()
        self.initialValueDropDown.toggle()
        self.images.removeAll()
    }
    
    var body: some View {
        VStack {
            VStack{
                HStack(spacing: 0) {
                    VStack {
                        Text("Create story")
                            .modifier(FontModifier(weight: .bold, size: .title, color: .darkGray))
                    }
                    Spacer()
                    Button {
                        reinitValues()
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
                .padding(.horizontal, 30)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack{
                        HStack {
                            PickerAnimal(kindOfAnimal: self.$animal, initialValue: $initialValuePickerAnimal)
                        }
                        .padding(.top, 10)
                        .padding(.horizontal, 30)
                        DropDownView(
                            title: $dropDownTitle,
                            items: $items ,
                            showOptions: $showKindstory,
                            kindOfStory: $kindOfStory,
                            initialValue: $initialValueDropDown, action: {
                                DispatchQueue.main.async {
                                    self.showKindstory.toggle()
                                }
                            })
                            .padding(.vertical, 10)
                            .padding(.horizontal, 30)
                        
                        VStack(spacing: 20){
                            VStack{
                                HStack(spacing: 0) {
                                    ForEach(images, id: \.id) { image in
                                        image.image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width:self.screen ,height: self.screen)
                                            .frame(maxWidth:self.screen ,maxHeight: self.screen)
                                            .clipShape(RoundedRectangle(cornerRadius: 0))
                                            .offset(x: self.x)
                                            .modifier(DraggableView(x: self.$x, count: self.$count, screen: self.$screen, dataCount: self.$dataCount))
                                    }
                                }.frame(width: screen)
                                .offset(x: self.op)
                            }
                            .animation(.spring())
                            
                            VStack(spacing: 20){
                                if images.count < 4{
                                    HStack{
                                        Text("Add more pictures")
                                            .modifier(FontModifier(weight: .bold, size: .paragraph, color: .redSalsa))
                                        Spacer()
                                        Button(action: {
                                                isShowPhotoLibrary.toggle()
                                        }, label: {
                                            DesignImage.storyAdd.image
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                        }) 
                                    }
                                }
                                TextViewForstory(text: $text, remainingText: remaining)
                                LocationInfoView(city: $locationManager.city, address: $locationManager.address)
                                SwitchShare(shareInFb: $shareInFb)
                                NormalButton(textButton: "Publish story"){
                                    self.createstory()
                                    self.isShowing = false
                                    self.reinitValues()
                                }
                                .padding(.bottom, 20)
                            }
                            .padding(.horizontal, 30)
                            
                        }
                        .padding(.bottom, keyboardHandler.keyboardHeight)
                        .animation(.default)
                        Spacer()
                    }
                }
            }
            
        }
        .background(ThemeColors.white.color)
        .cornerRadius(20)
        .onTapGesture {
            self.isFocused = false
            self.showKindstory = false
            self.hideKeyboard()
        }
        .onAppear{
            self.images.append(imageSelected)
            self.op = ((self.screen * CGFloat(images.count)) / 2) - (self.screen / 2)
            self.dataCount = images.count
        }
        .onChange(of: imageSelected){ newImage in
            self.images.append(newImage)
        }
        .onChange(of: images.count){ value in
            self.op = ((self.screen * CGFloat(images.count)) / 2) - (self.screen / 2)
            self.dataCount = images.count
        }
        .offset(y: self.isShowing ? 0 :  UIScreen.main.bounds.height)
        .animation(.default)
        .sheet(isPresented: $isShowPhotoLibrary, onDismiss: loadImage, content: {
            ImagePicker(selectedImage: $inputImage)
                .ignoresSafeArea(edges: .all)
        })
    }
    
    func loadImage(){
        if let newImage = inputImage {
            if let imageData = newImage.jpegData(compressionQuality: 0.8){
                let image = Image(uiImage: newImage)
                let imageSelected = ImageSelected(imageData: imageData, image: image)
                self.images.append(imageSelected)
            }
        }
    }
}

struct CreatestoryView_Previews: PreviewProvider {
    static var previews: some View {
        CreateStoryView(
            imageSelected: .constant(ImageSelected(imageData: Data(), image: Image(""))),
            isShowing: .constant(true)
        )
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
