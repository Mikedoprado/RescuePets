//
//  DraggableView.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/27/21.
//

import SwiftUI

struct DraggableView: ViewModifier {

    @Binding var x: CGFloat
    @Binding var count : CGFloat
    @Binding var screen : CGFloat
    @Binding var dataCount : Int
    
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width > 0 {
                            self.x = value.location.x
                        }else {
                            self.x = value.location.x - self.screen
                        }
                    }
                    .onEnded{ value in
                        if value.translation.width > 0 {
                            if value.translation.width > ((self.screen) / 2) && Int(self.count) != 0 {
                                self.count -= 1
                                self.x = -((self.screen) * self.count)
                            }
                            else{
                                self.x = -((self.screen) * self.count)
                            }
                        }
                        else{
                            if -value.translation.width > ((self.screen) / 2) && Int(self.count) != (dataCount - 1){
                                self.count += 1
                                self.x = -((self.screen) * self.count)
                            }
                            else{
                                self.x = -((self.screen) * self.count)
                            }
                        }
                    }
            )
    }
}


