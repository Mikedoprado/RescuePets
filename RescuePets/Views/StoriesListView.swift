//
//  StoriesListView.swift
//  RescuePets
//
//  Created by Michael do Prado on 10/1/21.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import SDWebImageSwiftUI

struct StoriesListView : View {
    
    @ObservedObject var storyViewModel : StoryViewModel
    
    var kind : KindStory
    
    func handleTableView(){
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().backgroundColor = UIColor(ThemeColors.redSalsaDark.color)
        UITableView.appearance().frame = UIScreen.main.bounds
    }
    
    enum KindStory {
        case general, accepted, created
    }
    
    func stories() -> [StoryCellViewModel]{
        switch kind {
        case .general:
            return storyViewModel.storyCellViewModels
        case .accepted:
            return storyViewModel.storyCellViewModelsAccepted
        case .created:
            return storyViewModel.storyCellViewModelsCreated
        }
    }
    
    var body: some View {
        VStack(spacing: 0){
            List{
                ForEach(stories()){ storyCellVM in
                    if kind == .general{
                        StoryView(storyCellViewModel: storyCellVM, storyViewModel: storyViewModel)
                            .padding(.leading, -10)
                            .overlay(NavigationLink(destination: DetailView(story: storyCellVM, storyViewModel: storyViewModel)) {}
                                        .buttonStyle(.plain)
                                        .listRowInsets(EdgeInsets())
                                        .opacity(0.0)
                            )
                    }else{
                        StoryCellView(storyCellViewModel: storyCellVM)
                            .padding(.leading, -10)
                            .overlay(NavigationLink(destination: DetailView(story: storyCellVM, storyViewModel: storyViewModel)) {}
                                        .buttonStyle(.plain)
                                        .listRowInsets(EdgeInsets())
                                        .opacity(0.0)
                            )
                    }
                }
                .listRowBackground(Color.clear)
            }
            .buttonStyle(.plain)
            
        }
        .background(Color.clear)
        .padding(.top, 150)
        .padding(.bottom, 80)
        .onAppear {
            self.handleTableView()
        }
    }
}
// MARK: CellView Story General
struct StoryView: View {
    
    @ObservedObject var storyCellViewModel: StoryCellViewModel
    @ObservedObject var storyViewModel: StoryViewModel
    
    var body: some View {
        VStack(spacing:0) {
            ZStack {
                AnimatedImage(url: URL(string: storyCellViewModel.presentImage))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(ThemeColors.whiteClear.color)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                VStack{
                    VStack{
                        HStack(spacing: 5){
                            Spacer()
                            CounterHelpers(storyCellViewModel: storyCellViewModel, color: ThemeColors.white.color)
                        }
                        .padding(.horizontal, 20)
                        Spacer()
                    }
                    .padding(.top, 30)
                    
                    Spacer()
                    StoryInternViewCell(storyCellViewModel: storyCellViewModel, storyViewModel: storyViewModel)
                }
                
            }
            
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StoryInternViewCell: View {
    
    @ObservedObject var storyCellViewModel: StoryCellViewModel
    @ObservedObject var storyViewModel: StoryViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    @State var isPressed = false
    
    func handleButton(_ isPressed: Bool) -> Bool {
        if isPressed {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isPressed = false
            }
        }
        return self.isPressed
    }
    
    var body: some View {
        VStack(spacing:0) {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(storyCellViewModel.kindOfStory)
                        .modifier(FontModifier(weight: .bold, size: .subtitle, color: .redSalsa))
                    HStack(spacing: 10){
                        Image("pin\(storyCellViewModel.kindOfAnimal)Active" )
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(ThemeColors.redSalsa.color)
                            .clipShape(Circle())
                        VStack(alignment: .leading,spacing: 0){
                            Text(storyCellViewModel.username.capitalized)
                                .modifier(FontModifier(weight: .regular, size: .caption, color: .gray))
                            Text(storyCellViewModel.timestamp)
                                .modifier(FontModifier(weight: .bold, size: .caption, color: .halfGray))
                        }
                        Spacer()
                    }
                }
                Spacer()
                if userViewModel.userCellViewModel.user.id != storyCellViewModel.userId && storyCellViewModel.numHelpers <= 50 {
                    
                    Image(!storyCellViewModel.acceptedStory ? "storyAdd" : "storyAcept")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                        .onTapGesture {
                            isPressed = true
                            storyCellViewModel.acceptedStory.toggle()
                            storyViewModel.update(storyCellViewModel)
                        }
                        .disabled(handleButton(isPressed))
                }
            }
            .padding(.all, 20)
        }
        .background(ThemeColors.white.color)
        .cornerRadius(20)
        .padding(.bottom, 20)
        .padding(.horizontal, 20)
    }
}

// MARK:  DetailView

struct DetailView : View {
    
    @ObservedObject var story: StoryCellViewModel
    @ObservedObject var storyViewModel: StoryViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var isPressed = false
    
    func handleButton(_ isPressed: Bool) -> Bool {
        if isPressed {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isPressed = false
            }
        }
        return self.isPressed
    }

    func dismissView(){
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        
        HeaderActiveDetail(story: story, storyViewModel: storyViewModel, isPressed: $isPressed, action: {
            self.dismissView()
        })
            .padding(.horizontal, 20)
        
        InteractionActiveView(story: story, storyViewModel: storyViewModel)
            .padding(.horizontal, 20)
            .padding(.top, 20)
        
        /// MARK: info scrollable description, carrousel, location Info (map, city and address)
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20){
                
                Text(story.description)
                    .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)

                CarrouselActiveDetailView(story: story)
                
                VStack(alignment: .leading, spacing: 20){
                    MapActiveView(city: story.city, latitude: story.latitude, longitude: story.longitude)
                        .frame(height: 180)
                        .background(ThemeColors.whiteGray.color)
                    
                    LocationInfoView(city: story.city , address: story.address)
                        .frame(height: 120)
                        .background(ThemeColors.whiteGray.color)
                        .cornerRadius(20)
                        .padding(.top, -50)
                        .padding(.horizontal, 20)
                }.onTapGesture {
                    withAnimation(.default) {

                    }
                }
                .padding(.bottom, 30)
            }.padding(.top, 20)
            Spacer()
                .navigationBarHidden(true)
        }
    }
}

struct HeaderActiveDetail: View {
    
    @ObservedObject var story: StoryCellViewModel
    @ObservedObject var storyViewModel: StoryViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @Binding var isPressed : Bool
    var action : () -> Void
    
    var body : some View{
        HStack{
            Text("Active")
                .modifier(FontModifier(weight: .bold, size: .title, color: .darkGray))
            Spacer()
            HStack{
                if userViewModel.userCellViewModel.user.id != story.userId && story.numHelpers <= 50 {
                    
                    Image(!story.acceptedStory ? "storyAdd" : "storyAcept")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                        .onTapGesture {
                            isPressed = true
                            story.acceptedStory.toggle()
                            storyViewModel.update(story)
                        }
                        .disabled(isPressed)
                }
                
                DesignImage.trash.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                
                DesignImage.closeBlack.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .onTapGesture {
                        self.action()
                    }
            }
        }
    }
}

struct InteractionActiveView: View {
    
    @ObservedObject var story: StoryCellViewModel
    @ObservedObject var storyViewModel: StoryViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body : some View {
        HStack{
            Image("pin\(story.kindOfAnimal)Active" )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            
            VStack (alignment: .leading){
                Text(story.kindOfStory)
                    .modifier(FontModifier(weight: .bold, size: .paragraph, color: .redSalsa))
                
                HStack {
                    Text(story.username.capitalized)
                        .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                    Spacer()
                }
            }
            HStack(spacing: 20){
                CounterHelpers(storyCellViewModel: story, color: ThemeColors.whiteGray.color)
                    .onTapGesture {
                        if story.numHelpers != 0 {

                        }
                    }
                if (story.userAcceptedStoryID.contains(userViewModel.userCellViewModel.id) || story.userId == userViewModel.userCellViewModel.id) {
                    Button{

                    }label:{
                        DesignImage.chatIcon.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                }
            }
        }
    }
}

struct CarrouselActiveDetailView : View {
    
    @ObservedObject var story: StoryCellViewModel
    
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
    
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            if story.images.count > 1 {
                HStack(spacing: 0){
                    ForEach(story.images, id: \.self) { url in
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
            }else{
                AnimatedImage(url: URL(string: story.images.first ?? ""))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
                    .background(ThemeColors.whiteGray.color)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: Example Views

struct Example2 : View {
    var body: some View {
        ZStack {
            ThemeColors.blueCuracao.color
            Text("Hello, Michael!")
                .foregroundColor(ThemeColors.white.color)
        }
        .ignoresSafeArea(edges: .top)
    }
}

struct Example3 : View {
    var body: some View {
        ZStack {
            ThemeColors.goldenFlow.color
            Text("Hello, Stella!")
                .foregroundColor(ThemeColors.darkGray.color)
        }
        .ignoresSafeArea(edges: .top)
    }
}


struct Example4 : View {
    var body: some View {
        ZStack {
            ThemeColors.whiteSmashed.color
            Text("Hello, Manuel!")
                .foregroundColor(ThemeColors.darkGray.color)
        }
        .ignoresSafeArea(edges: .top)
    }
}
