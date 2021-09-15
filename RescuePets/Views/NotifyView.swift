//
//  NotifyView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/23/21.
//

import SwiftUI

var screen = UIScreen.main.bounds

struct NotifyView: View {
    
    @StateObject var storyViewModel = StoryViewModel()
    @EnvironmentObject var userViewModel : UserViewModel
    @Binding var showNotify : Bool
    @Binding var isAnimating : Bool
    @State var changeView = false
    @State var showDetailsStory = false
    @State var isAnimatingActiveView = false
    @State var categories = ["General", "Accepted", "Created"]
    @State var selectedCategory = "General"
    @State var story : Story?
    @State var colorMenu = ThemeColors.redSalsa
    @State var storyCellViewModel : StoryCellViewModel?
    @Binding var showTabBar : Bool
    
    func getColor(story: Story) -> Color {
        switch story.animal.rawValue {
        case "Dog":
            return ThemeColors.blueCuracao.color
        case "Cat":
            return ThemeColors.redSalsa.color
        case "Bird":
            return ThemeColors.goldenFlow.color
        case "Other":
            return ThemeColors.darkGray.color
        default:
            return ThemeColors.whiteSmashed.color
        }
    }
    
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
    
    @ViewBuilder var body: some View {
        ZStack{
            VStack(spacing: 0) {
                VStack {
                    HeaderView(title: $selectedCategory, actionDismiss: {
                        dismissView()
                    }, color: .white, alignment: .center, closeButtonIsActive: false)
                    SelectorSection(categories: $categories, selectedCategory: $selectedCategory, color: $colorMenu)
                }
                .background(ThemeColors.redSalsa.color)
                .animation(.default)
                
                ScrollView(.vertical) {
                    if selectedCategory == "General"{
                        LazyVStack {
                            ForEach(storyViewModel.storyCellViewModels) { storyCellVM in
                                StoryCell(storyCellViewModel: storyCellVM, storyViewModel: storyViewModel)
                                    .padding(.vertical, 20)
                                    .onTapGesture {
                                        showStory(story: storyCellVM)
                                    }
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                    if selectedCategory == "Accepted"{
                        LazyVStack {

                            ForEach(storyViewModel.storyCellViewModelsAccepted) { storyCellVM in
                                StoryCellView(storyCellViewModel: storyCellVM, storyViewModel: storyViewModel, user: userViewModel.userCellViewModel.user)
                                    .onTapGesture {
                                        showStory(story: storyCellVM)
                                    }
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                    if selectedCategory == "Created"{
                        LazyVStack {
                            ForEach(storyViewModel.storyCellViewModelsCreated) { storyCellVM in
                                StoryCellView(storyCellViewModel: storyCellVM, storyViewModel: storyViewModel, user: userViewModel.userCellViewModel.user)
                                    .onTapGesture {
                                        showStory(story: storyCellVM)
                                    }
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }

                }
                Spacer()
            }
            .frame(width: screen.width)
            .background(ThemeColors.redSalsa.color)
//            .clipShape(RoundedRectangle(cornerRadius: 20))

            if showDetailsStory {
                if let story = storyCellViewModel{
                    ActiveDetailView(storyCellViewModel: story, storyViewModel: storyViewModel, showStory: $showDetailsStory, isAnimating: $isAnimatingActiveView, user: userViewModel.userCellViewModel.user, showTabBar: $showTabBar)
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



