//
//  NotifyView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/23/21.
//

import SwiftUI

var screen = UIScreen.main.bounds

struct NotifyView: View {
    
    @ObservedObject var storyViewModel = StoryViewModel()
    @Binding var showNotify : Bool
    @Binding var isAnimating : Bool
    @State var changeView = false
    @State var showDetailsStory = false
    @State var isAnimatingActiveView = false
    @State var categories = ["General", "Accepted", "Created"]
    @State var selectedCategory = "General"
    @State var story : Story?
    @Namespace private var ns
    @Binding var user : User
    
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
    
    var body: some View {
        ZStack{
            
            VStack(spacing: 0) {
                
                VStack {
                    HStack {
                        Text(selectedCategory)
                            .modifier(FontModifier(weight: .bold, size: .title, color: .white))
                        Spacer()
                        Button {
                            self.isAnimating.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.showNotify.toggle()
                            }
                        } label: {
                            DesignImage.closeWhite.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                        }
                    }
                    .padding(.top, 50)
                    .padding(.horizontal, 30)
                    
                    SelectorSection(categories: $categories, selectedCategory: $selectedCategory)

                }
                .background(!self.changeView ? ThemeColors.redSalsa.color : ThemeColors.blueCuracao.color)
                .animation(.default)

                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(storyViewModel.storyCellViewModels) { storyCellVM in
                            Button(action: {
                                self.story = storyCellVM.story
                                self.showDetailsStory.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.isAnimatingActiveView = true
                                }
                            }, label: {
                                StoryCellView(storyCellViewModel: storyCellVM, storyViewModel: storyViewModel, user: $user)
                            })
                            
                        }
                    }
                }
            }
            .frame(width: screen.width)
            .background(ThemeColors.white.color)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .offset(y: self.isAnimating ? 0 :  UIScreen.main.bounds.height)
            .animation(.default)
            if showDetailsStory {
                ActiveDetailView(storyCellViewModel: StoryCellViewModel(story: story!), storyViewModel: storyViewModel, showstory: $showDetailsStory, isAnimating: $isAnimatingActiveView, user: $user)
            }
        }
    }
}

//struct NotifyView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotifyView(showNotify: .constant(true), isAnimating: .constant(true))
//    }
//}



