//
//  HelpersExtensions.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/11/21.
//

import Combine
import Foundation
import SwiftUI

// allow to remove the leaks in the combine assign
extension Publisher where Failure == Never {
//    func weakAssign<T: AnyObject>(
//        to keyPath: ReferenceWritableKeyPath<T, Output>,
//        on object: T
//    ) -> AnyCancellable {
//        sink { [weak object] value in
//            object?[keyPath: keyPath] = value
//        }
//    }
    func weakAssign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
      sink { [weak root] in
        root?[keyPath: keyPath] = $0
      }
    }
}

class Timestamp {
    static func setupTimeStamp(time: Int) -> String {
        
        let timestampDate = Date(timeIntervalSince1970: Double(time))
        let now = Date()
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
        let diff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
        
        var timeText = ""
        
        if diff.second! <= 0 {
            timeText = "Now"
        }
        if diff.second! > 0 && diff.minute! == 0 {
            timeText = (diff.second == 1) ? "\(diff.second!) second ago" : "\(diff.second!) seconds ago"
        }
        if diff.minute! > 0 && diff.hour! == 0 {
            timeText = (diff.second == 1) ? "\(diff.minute!) minute ago" : "\(diff.minute!) minutes ago"
        }
        if diff.hour! > 0 && diff.day! == 0 {
            timeText = (diff.hour == 1) ? "\(diff.hour!) hour ago" : "\(diff.hour!) hours ago"
        }
        if diff.day! > 0 && diff.weekOfMonth! == 0 {
            timeText = (diff.day == 1) ? "\(diff.day!) day ago" : "\(diff.day!) days ago"
        }
        if diff.weekOfMonth! > 0 {
            timeText = (diff.weekOfMonth == 1) ? "\(diff.weekOfMonth!) week ago" : "\(diff.weekOfMonth!) weeks ago"
        }
        return timeText
    }
}

struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
