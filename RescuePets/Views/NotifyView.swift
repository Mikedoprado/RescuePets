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
    @State var alert : AlertCellViewModel?
    @Binding var showNotify : Bool
    @Binding var isAnimating : Bool
    @State var changeView = false
    @State var showDetailsAlert = false
    @State var isAnimatingActiveView = false
    @State var categories = ["General", "Acepted", "Created"]
    @State var selectedCategory = "General"
    @Namespace private var ns
    
    func getColor(alert: Alert) -> Color {
        switch alert.animal.rawValue {
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
                        ForEach(alertListVM.alertCellViewModels) { alertCellVM in
                            Button(action: {
                                self.alert = alertCellVM
                                self.showDetailsAlert.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.isAnimatingActiveView = true
                                }
                            }, label: {
                                AlertCellView(alert: alertCellVM)
                                    .padding(.horizontal, 30)
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
            
            if showDetailsAlert {
                ActiveDetailView(alert: alert!, showAlert: $showDetailsAlert, isAnimating: $isAnimatingActiveView)
                    
            }
            
        }
        
    }
}

struct NotifyView_Previews: PreviewProvider {
    static var previews: some View {
        NotifyView(showNotify: .constant(false), isAnimating: .constant(false))
    }
}


