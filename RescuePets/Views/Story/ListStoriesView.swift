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
    var action : (StoryCellViewModel)->()
    var kind : KindStory
    
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
                        self.action(storyCellVM)
                    })
                        .padding(.top, 20)
                    
                }else{
                    StoryCellView(storyCellViewModel: storyCellVM, storyViewModel: storyViewModel)
                        .padding(.top, 10)
                        .onTapGesture {
                            self.action(storyCellVM)
                        }
                }
            }
            .listRowBackground(ThemeColors.redSalsa.color)
            .listRowSeparator(.hidden)
        }
        .cornerRadius(0)
        .padding(.horizontal, -20)
        .onAppear{
            UITableView.appearance().backgroundColor = UIColor(red: 0.9647058824, green: 0.2509803922, blue: 0.3098039216, alpha: 1)
        }
    }
}

//struct ListStoriesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListStoriesView()
//    }
//}
