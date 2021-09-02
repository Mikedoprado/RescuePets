//
//  CustomHeader.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/12/21.
//

import SwiftUI

struct CustomHeader: View {
    
    @ObservedObject var storyCellViewModel : StoryCellViewModel
    @ObservedObject var storyViewModel : StoryViewModel
    @Binding var user : User
    @Binding var showingAlert : Bool
    var action: () -> Void
    @Binding var sectionTitle : String
    
    var body: some View {
        HStack {
            Text(sectionTitle)
                .modifier(FontModifier(weight: .bold, size: .title, color: .darkGray))
            Spacer()
            HStack(spacing: 30) {
                if user.id != storyCellViewModel.userId {
//                    Button {
//                        storyCellViewModel.story.isActive.toggle()
//                        storyViewModel.update(storyCellViewModel.story, user: user)
//                    } label: {
                        Image(storyCellViewModel.acceptedStory)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25, alignment: .center)
                            .onTapGesture {
                                storyCellViewModel.story.isActive.toggle()
                                storyViewModel.update(storyCellViewModel.story, user: user)
                            }
//                    }
                }
                if user.id == storyCellViewModel.userId {
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
                                self.storyViewModel.remove(storyCellViewModel.story)
                                withAnimation {
                                    self.action()
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                Button {
                    withAnimation {
                        self.action()
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
    }
}

//struct CustomHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomHeader(storyViewModel: StoryViewModel, storyCellViewModel: StoryCellViewModel(story: Story()), user: , showingAlert: , action: )
//    }
//}
