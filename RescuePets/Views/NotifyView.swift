//
//  NotifyView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/23/21.
//

import SwiftUI

var screen = UIScreen.main.bounds

struct NotifyView: View {
    
    @ObservedObject var alertListVM = AlertViewModel()
    @ObservedObject var messagesListVM = MessageViewModel()
    
    @State var changeView = false
    var message = messages
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack {
                    Text("Notifications")
                        .modifier(FontModifier(weight: .bold, size: .title, color: .white))
                    Spacer()
                    Button {

                    } label: {
                        DesignImage.closeWhite.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25, alignment: .center)
                    }
                }
                .padding(.top, 30)
                .padding(.horizontal, 30)
                
                SelectorSection(changeView: $changeView)
                
            }
            .background(!self.changeView ? ThemeColors.redSalsa.color : ThemeColors.blueCuracao.color)
            .animation(.default)
            
            
            HStack(spacing: 0){
                VStack {
                    LazyVStack {
                        ForEach(alertListVM.alertCellViewModels) { alertCellVM in
                            AlertCellView(alert: alertCellVM)
                                .padding(.horizontal, 30)
                        }
                    }.frame(width: screen.width)
                    Spacer()
                }
                
                VStack {
                    LazyVStack{
                        ForEach(messagesListVM.messageCellVM) { inbox in
                            MessageCellView(message: inbox)
                                .padding(.horizontal, 30)
                        }
                    }.frame(width: screen.width)
                    Spacer()
                }
            }
            .padding(!self.changeView ? .leading : .trailing, screen.width)
            .animation(.default)
            Spacer()
        }
        .frame(width: screen.width)
        .background(ThemeColors.white.color)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        
    }
}

struct NotifyView_Previews: PreviewProvider {
    static var previews: some View {
        NotifyView()
    }
}

struct SelectorSection: View {
    
    @Binding var changeView : Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(ThemeColors.white.color)
                .frame(width: 200, height: 40)
            
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(!self.changeView ? ThemeColors.redSalsa.color : ThemeColors.blueCuracao.color)
                .frame(width: !self.changeView ? CGFloat(80) : CGFloat(100), height: 30)
                .padding(self.changeView ? .leading : .trailing, self.changeView ? CGFloat(70) : CGFloat(100))
                .animation(.default)
            HStack{
                Button {
                    self.changeView = false
                }label: {
                    Text("Alerts")
                        .modifier(FontModifier(weight: .regular, size: .paragraph, color: !self.changeView ?  .white : .blueCuracao))
                        .animation(.default)
                }
                
                Spacer()
                Button {
                    self.changeView = true
                } label: {
                    Text("Messages")
                        .modifier(FontModifier(weight: .regular, size: .paragraph, color: !self.changeView ?  .redSalsa : .white))
                        .animation(.default)
                }
                
            }
            .padding(.horizontal, 25)
        }
        .frame(width: 200, height: 40)
        .padding(.bottom, 20)
    }
}
