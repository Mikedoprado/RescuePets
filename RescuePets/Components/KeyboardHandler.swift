//
//  KeyboardHandler.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/24/21.
//

import Combine
import SwiftUI

final class KeyboardHandler: ObservableObject {
    
    @Published private(set) var keyboardHeight: CGFloat = 0
    
    private var cancellable =  Set<AnyCancellable>()
    
    init() {
        
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap{($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height}
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.keyboardHeight, on: self)
            .store(in: &cancellable)
        
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .compactMap{ _ in CGFloat.zero }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.keyboardHeight, on: self)
            .store(in: &cancellable)
    }
//    private let keyboardWillShow = NotificationCenter.default
//         .publisher(for: UIResponder.keyboardWillShowNotification)
//         .compactMap{($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height}
//
//    private let keyboardWillHide = NotificationCenter.default
//        .publisher(for: UIResponder.keyboardWillHideNotification)
//        .compactMap{ _ in CGFloat.zero }
    
//    init(){
//        cancellable = Publishers.Merge(keyboardWillShow, keyboardWillHide)
//            .subscribe(on: DispatchQueue.main)
//            .weakAssign(to: \.self.keyboardHeight, on: self)
//    }
}
