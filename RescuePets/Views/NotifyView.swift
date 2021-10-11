//
//  NotifyView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/23/21.
//

import SwiftUI

var screen = UIScreen.main.bounds

struct NotifyView: View {
    
    @ObservedObject var storyViewModel : StoryViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    @Binding var showNotify : Bool
    @Binding var isAnimating : Bool
    @State var changeView = false
    @State var showDetailsStory = false
    @State var isAnimatingActiveView = false
    @State var categories = ["General", "Accepted", "Created"]
    @State var selectedCategory = "General"
    @State var colorMenu = ThemeColors.redSalsa
    @State var storyCellViewModel : StoryCellViewModel?
    @Binding var showTabBar : Bool
    
    func dismissView(){
        self.isAnimating.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showNotify.toggle()
            
        }
    }
    
    func showStory(story: StoryCellViewModel){
        self.storyCellViewModel = story
        self.showDetailsStory.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isAnimatingActiveView = true
            self.showTabBar = false
        }
    }
    
    func handleTableView(){
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().backgroundColor = UIColor(red: 0.9647058824, green: 0.2509803922, blue: 0.3098039216, alpha: 1)
    }
    
    func handleOffset(category: String) -> CGFloat{
        switch category{
        case "General":
            return screen.width + 40
        case "Accepted":
            return 0
        case "Created":
            return -screen.width - 40
        default:
            return 0
        }
    }
    
    var body: some View {
        ZStack{
            HStack(spacing: 0){
                ListStoriesView(storyViewModel: storyViewModel, isEnabled: $showDetailsStory, action: { story in
                    self.showStory(story: story)
                }, kind: .general, actionLoadMoreStories:{
                    storyViewModel.storyRepository.loadGeneralStories() 
                })
                ListStoriesView(storyViewModel: storyViewModel, isEnabled: $showDetailsStory, action: { story in
                    self.showStory(story: story)
                }, kind: .accepted, actionLoadMoreStories:{})
                ListStoriesView(storyViewModel: storyViewModel, isEnabled: $showDetailsStory, action: { story in
                    self.showStory(story: story)
                }, kind: .created, actionLoadMoreStories:{})

            }
            .offset(x: self.handleOffset(category: selectedCategory))
            .padding(.bottom, 80)
            .padding(.top, 120)
            VStack{
                VStack{
                    HeaderView(title: $selectedCategory, actionDismiss: {
                    }, color: .white, alignment: .center, closeButtonIsActive: false)
                        .frame(width: screen.width)
                    SelectorSection(categories: $categories, selectedCategory: $selectedCategory, color: $colorMenu)
                        .padding(.bottom, 20)
                    
                }
                .background(ThemeColors.redSalsa.color)
                Spacer()
            }
            
            if showDetailsStory {
                if storyCellViewModel != nil {
                    ActiveDetailView(storyCellViewModel: storyCellViewModel!, storyViewModel: storyViewModel, showStory: $showDetailsStory, isAnimating: $isAnimatingActiveView, user: userViewModel.userCellViewModel.user, showTabBar: $showTabBar)
                        .frame(width: screen.width)
                }
            }
        }
        .frame(width: screen.width)
        .background(ThemeColors.redSalsa.color)
        .ignoresSafeArea()
        .onAppear {
            print(self.storyViewModel.storyCellViewModels.count)
            self.handleTableView()
        }
    }
}





