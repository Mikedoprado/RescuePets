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
    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                ZStack{
                    VStack{
                        switch selectedCategory {
                        case "General" :
                            ListStoriesView(storyViewModel: storyViewModel, action: { story in
                                self.showStory(story: story)
                            }, kind: .general)
                        case "Accepted" :
                            ListStoriesView(storyViewModel: storyViewModel, action: { story in
                                self.showStory(story: story)
                            }, kind: .accepted)
                        case "Created" :
                            ListStoriesView(storyViewModel: storyViewModel, action: { story in
                                self.showStory(story: story)
                            }, kind: .created)
                        default:
                            ListStoriesView(storyViewModel: storyViewModel, action: { story in
                                self.showStory(story: story)
                            }, kind: .general)
                        }
                    }
                    .padding(.bottom, 80)
                    .padding(.top, 120)
                    VStack{
                        VStack {
                            HeaderView(title: $selectedCategory,
                                       actionDismiss: {},
                                       color: .white,
                                       alignment: .center,
                                       closeButtonIsActive: false)
                            SelectorSection(categories: $categories, selectedCategory: $selectedCategory, color: $colorMenu)
                                .padding(.bottom, 20)
                        }
                        .background(ThemeColors.redSalsa.color)
                        Spacer()
                    }
                }
                
            }
            .background(ThemeColors.redSalsa.color)
            
            if showDetailsStory {
                if storyCellViewModel != nil {
                    ActiveDetailView(storyCellViewModel: storyCellViewModel!, storyViewModel: storyViewModel, showStory: $showDetailsStory, isAnimating: $isAnimatingActiveView, user: userViewModel.userCellViewModel.user, showTabBar: $showTabBar)
                }
            }
        }
    }
}

//struct NotifyView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotifyView(showNotify: .constant(true), isAnimating: .constant(true))
//    }
//}




