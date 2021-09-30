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
    
    @ObservedObject var storyCellViewModel : StoryCellViewModel
    @ObservedObject var storyViewModel : StoryViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    @Binding var showStory : Bool
    @Binding var isAnimating : Bool
    @State var showMapFullScreen = false
    @State private var showingAlert = false
    @Namespace var animation
    var user : User
    @State var sectionTitle = "Story"
    
    @State var screen = UIScreen.main.bounds.width
    @State var showMessage = false
    @State var animShowMessage = false
    @Binding var showTabBar : Bool
    @State var showHelper = false
    @State var animateHelpers = false
    
    
    func dismissView(){
        self.isAnimating.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showStory.toggle()
            self.showTabBar = true
        }
    }
    
    private func getScale(proxy: GeometryProxy) -> CGFloat {
        withAnimation {
            var scale: CGFloat = 1
            
            let x = proxy.frame(in: .global).minX
            
            let diff = abs(x - 30)
            if diff < 100 {
                scale = 1 + (100 - diff) / UIScreen.main.bounds.width
            }
            
            return scale
        }
        
    }
    
    fileprivate func showComments() {
        withAnimation {
            self.showMessage = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.animShowMessage = true
            }
        }
        
    }
    
    fileprivate func showHelpers(){
        withAnimation {
            self.showHelper = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.animateHelpers = true
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                ZStack {
                    VStack{
                        // MARK: header
                        CustomHeader(storyCellViewModel: storyCellViewModel, storyViewModel: storyViewModel, user: user, showingAlert: $showingAlert, action: {
                            dismissView()
                        }, sectionTitle: $sectionTitle)
                        HStack {
                            Image("pin\(storyCellViewModel.kindOfAnimal)Active" )
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                            
                            VStack (alignment: .leading){
                                Text(storyCellViewModel.kindOfStory)
                                    .modifier(FontModifier(weight: .bold, size: .paragraph, color: .redSalsa))
                                
                                HStack {
                                    Text(storyCellViewModel.username.capitalized)
                                        .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                                    Spacer()
                                }
                            }
                            HStack(spacing: 20){
                                CounterHelpers(storyCellViewModel: storyCellViewModel, color: ThemeColors.whiteGray.color)
                                    .onTapGesture {
                                        if storyCellViewModel.numHelpers != 0 {
                                            self.showHelpers()
                                        }
                                    }
                                if (storyCellViewModel.userAcceptedStoryID.contains(userViewModel.userCellViewModel.id) || storyCellViewModel.userId == userViewModel.userCellViewModel.id) {
                                    Button{
                                        showComments()
                                    }label:{
                                        DesignImage.chatIcon.image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                    }
                                }
                            }
                            
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    }
                }
                
                // MARK: info scrollable
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20){
                        
                        Text(storyCellViewModel.description)
                            .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 20)
                        
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0){
                                ForEach(storyCellViewModel.images, id: \.self) { url in
                                    GeometryReader{ proxy in
                                        let scale = getScale(proxy: proxy)
                                        
                                        ImagePet(url: url)
                                            .cornerRadius(10)
                                            .padding(.top, 30)
                                            .padding(.horizontal, 30)
                                            .scaleEffect(CGSize(width: scale, height: scale))
                                    }
                                    .frame(width:UIScreen.main.bounds.width / 1.2 ,height: UIScreen.main.bounds.width - 50)
                                    
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        VStack(alignment: .leading, spacing: 20){
                            MapActiveView(city: storyCellViewModel.city, latitude: storyCellViewModel.latitude, longitude: storyCellViewModel.longitude)
                                .frame(height: 180)
                                .background(ThemeColors.whiteGray.color)
                            
                            LocationInfoView(city: storyCellViewModel.city , address: storyCellViewModel.address)
                                .frame(height: 120)
                                .background(ThemeColors.whiteGray.color)
                                .cornerRadius(20)
                                .padding(.top, -50)
                                .padding(.horizontal, 20)
                        }.onTapGesture {
                            withAnimation(.default) {
                                self.showMapFullScreen.toggle()
                            }
                        }
                        .padding(.bottom, 30)
                    }.padding(.top, 20)
                    Spacer()
                }
                
            }
            .background(ThemeColors.white.color)
            .offset(y: self.isAnimating ? 0 :  UIScreen.main.bounds.height)
            .animation(.spring(), value: self.isAnimating)
            
            if showMapFullScreen {
                MapInfoView(city: storyCellViewModel.city, latitude: storyCellViewModel.latitude, longitude: storyCellViewModel.longitude, address: storyCellViewModel.address, animView: $showMapFullScreen)
            }
            if showMessage {
                CommentView(showMessage: $showMessage, animShowMessage: $animShowMessage, commentViewModel: CommentViewModel(storyId: storyCellViewModel.id), storyId: storyCellViewModel.id)
            }
            if showHelper {
                StoryHelpersView(storyCellViewModel: storyCellViewModel, showHelpers: $showHelper, animateHelpers: $animateHelpers )
            }
        }
    }
}

//struct ActiveDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActiveDetailView(storyCellViewModel: StoryCellViewModel(story: Story()), showstory: .constant(true), isAnimating: .constant(true))
//    }
//}

struct ImagePet: View {
    var url : String
    var body: some View {
        AnimatedImage(url: URL(string: url))
            .resizable()
            .scaledToFill()
            .frame(width:UIScreen.main.bounds.width / 1.2 - 60, height: UIScreen.main.bounds.width / 1.2 - 60)
            .background(ThemeColors.whiteGray.color)
    }
}
