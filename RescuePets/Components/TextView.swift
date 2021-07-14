//
//  TextView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/21/21.
//

import Foundation
import UIKit
import SwiftUI

class RemaininInt: ObservableObject {
    @Published var remain : Int
    
    init(remain: Int) {
        self.remain = remain
    }
}

struct TextView: UIViewRepresentable {
    
    @Binding var text : String
    var placeholder: String = "Write your description..."
    var remain : RemaininInt
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 117/255, green: 114/255, blue: 114/255, alpha: 1),
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
        ]
        view.textContainerInset = .init(top: 10, left: 5, bottom: 5, right: 5)
        view.attributedText = NSAttributedString(string: placeholder,
        attributes:attributes as [NSAttributedString.Key : Any])
        view.font = UIFont.systemFont(ofSize: 16)
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1).cgColor
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.textColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        
        uiView.text = text != "" ? text : placeholder
        uiView.textColor = text != "" ? UIColor(red: 117/255, green: 114/255, blue: 114/255, alpha: 1) : UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        var parent : TextView

        init(_ parent: TextView) {
            
            self.parent = parent
            
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            //do not allow white lines (enter)
            guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {return false}
            //stop entry while reached 101 characters
            return textView.text.count + (text.count - range.length) <= 250

        }
        
        func textViewDidChange(_ textView: UITextView){
            parent.text = textView.text
            // calculation of characters
            let allowed = 250
            let typed = textView.text.count
            let remaining = allowed - typed
            parent.remain.remain = remaining
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1){
                textView.text = ""
                textView.textColor =  UIColor(red: 117/255, green: 114/255, blue: 114/255, alpha: 1)
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == ""{
                textView.text = parent.placeholder
                textView.textColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
            }
        }
    }

}

struct TextViewForAlert: View {
    
    @Binding var text : String
    @ObservedObject var remainingText : RemaininInt
    
    var body: some View {
        ZStack {
            TextView(text: $text, remain: remainingText)
                .frame(height: 150)
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    Text("\(remainingText.remain)/250")
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                        .foregroundColor(ThemeColors.halfGray.color)
                }
            }
            .padding(.bottom, 10)
            .padding(.trailing, 10)
        }.frame(height: 150)
    }
}
