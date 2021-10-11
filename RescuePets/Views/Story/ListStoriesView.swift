//
//  ListStoriesView.swift
//  RescuePets
//
//  Created by Michael do Prado on 9/23/21.
//

import SwiftUI

struct ListStoriesView: View {
    
    @ObservedObject var storyViewModel : StoryViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    @Binding var isEnabled : Bool
    var action : (StoryCellViewModel)->()
    var kind : KindStory
    var actionLoadMoreStories : ()-> Void
    
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
        List{
            ForEach(stories()){ storyCellVM in
                if kind == .general{
                    
                    StoryCell(storyCellViewModel: storyCellVM, storyViewModel: storyViewModel, actionHelp: {
                        storyViewModel.update(storyCellVM.story, user: userViewModel.userCellViewModel.user)
                    }, actionShowActive: {
                        if !isEnabled {
                            self.action(storyCellVM)
                        }
                    })
                        .padding(.top, 20)
                        .onAppear {
                            if storyCellVM.id == storyViewModel.storyCellViewModels.last?.id {
                                self.actionLoadMoreStories()

                            }
                        }
                }else{
                    StoryCellView(storyCellViewModel: storyCellVM, storyViewModel: storyViewModel)
                        .padding(.top, 10)
                        .disabled(!isEnabled)
                        .onTapGesture {
                            if !isEnabled {
                                self.action(storyCellVM)
                            }
                        }
                    
                        
                }
            }
            .listRowBackground(ThemeColors.redSalsa.color)
        }
        .frame(width: screen.width + 40)
        .cornerRadius(0)
        .ignoresSafeArea()

    }
}

//struct ListStoriesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListStoriesView()
//    }
//}
