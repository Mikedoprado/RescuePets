//
//  ActiveDetailView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/24/21.
//

import SwiftUI
import SDWebImageSwiftUI
import MapKit


struct ActiveDetailView: View {
    
    @Binding var showstory : Bool
    @Binding var isAnimating : Bool
    @State var showMapFullScreen = false
    @State private var showingAlert = false
    @Namespace var animation
    @State var city = "Medellin"
    @State var address = "Calle 13 # 43 D - 79"

//    var imagestory : String  {
//        switch currentstory.kindOfAnimal{
//        case "Dog":
//            return KindOfAnimal.Dog.animal
//        case "Cat":
//            return KindOfAnimal.Cat.animal
//        case "Bird":
//            return KindOfAnimal.Bird.animal
//        case "Other":
//            return KindOfAnimal.Other.animal
//        default:
//            return KindOfAnimal.Other.animal
//        }
//    }
    
//    var typeOfThreat : String {
//        switch currentstory.kindOfStory {
//        case "Rescue":
//            return TypeOfThreat.Rescue.rawValue
//        case "Adoption":
//            return TypeOfThreat.Adoption.rawValue
//        case "Wounded":
//            return TypeOfThreat.Wounded.rawValue
//        case "Maltreatment":
//            return TypeOfThreat.Maltreatment.rawValue
//        case "Desnutrition":
//            return TypeOfThreat.Desnutrition.rawValue
//        default:
//            return TypeOfThreat.Rescue.rawValue
//        }
//    }
    
    func dismissView(){
        self.isAnimating.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showstory.toggle()
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                ZStack {
                    VStack{
                        // MARK: header
                        HStack {
                            Text("Story")
                                .modifier(FontModifier(weight: .bold, size: .title, color: .darkGray))
                            Spacer()
                            HStack(spacing: 30) {
                                
                                    Button {

                                    } label: {
                                        DesignImage.storyAcept.image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 25, height: 25, alignment: .center)
                                    }
                                
                                
                                    Button {
                                        showingAlert = true
                                        
                                    } label: {
                                        DesignImage.trash.image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 25, height: 25, alignment: .center)
                                    }
                                    .alert(isPresented:$showingAlert) {
                                        Alert(
                                            title: Text("Are you sure you want to delete this?"),
                                            message: Text("There is no undo"),
                                            primaryButton: .destructive(Text("Delete")) {
//                                                self.storyListVM.removeStory(story: currentstory.story)
                                                withAnimation {
                                                    dismissView()
                                                }
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    }
                                
                                Button {
                                    withAnimation {
                                        dismissView()
                                    }
                                } label: {
                                    DesignImage.closeBlack.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25, alignment: .center)
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 50)
                        HStack {
                            DesignImage.pinCatActive.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                            
                            VStack (alignment: .leading){
                                Text("Maltreatment")
                                    .modifier(FontModifier(weight: .bold, size: .paragraph, color: .redSalsa))
                                
                                HStack {
                                    Text("username")
                                        .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                                    Spacer()
                                }
                            }
                            Button{
                                
                            }label:{
                                DesignImage.message.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    }
                }
                
                // MARK: info scrollable
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20){
                        
                        Text("currentstory.description")
                            .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 30)
                        
//                        AnimatedImage(url: URL(string:currentstory.image))
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(height: UIScreen.main.bounds.width)
//                            .background(ThemeColors.whiteGray.color)
                        
                        Button(action: {
                            withAnimation(.default) {
                                self.showMapFullScreen.toggle()
                            }
                        }, label: {
                            VStack(alignment: .leading, spacing: 20){
//                                MapActiveView(story: currentstory, latitude: currentstory.latitude, longitude: currentstory.longitude)
//                                    .frame(height: 180)
//                                    .background(ThemeColors.whiteGray.color)
                                
                                LocationInfoView(city: $city , address: $address)
                                    .frame(height: 120)
                                    .background(ThemeColors.whiteGray.color)
                                    .cornerRadius(20)
                                    .padding(.top, -50)
                                    .padding(.horizontal, 30)
                            }
                            .matchedGeometryEffect(id: "animation", in: animation, anchor: .center, isSource: true)
                        })
                    }.padding(.top, 20)
                    Spacer()
                }
                
            }
            .background(ThemeColors.white.color)
            .cornerRadius(20)
            .scaleEffect(self.isAnimating ? 1 :  0)
            .offset(y: self.isAnimating ? 0 :  UIScreen.main.bounds.height)
            .animation(.default)
            
            if showMapFullScreen {
//                MapInfoView(story: currentstory, animView: $showMapFullScreen)
//                    .matchedGeometryEffect(id: "animation", in: animation)
                
            }
        }
        
    }
}

struct ActiveDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveDetailView(showstory: .constant(true), isAnimating: .constant(true))
    }
}

//#if DEBUG
//var user1 = User(username: "Michael",email: "mike@gmail.com")
//var storyList = [
//    Story(id: "jsjdnakkw", username: user1.username!, userId: "ishdlae" , kindOfStory: .Rescue, timestamp: 0, animal: .Cat, image: ["helloImage"], city: "Medellin", address: "Calle 13 # 43D - 79", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque eget diam elementum, dictum leo quis, maximus velit. Donec tristique facilisis ipsum vitae lobortis.", isActive: false, latitude: 1.0, longitude: 1.0)
//]
//#endif
