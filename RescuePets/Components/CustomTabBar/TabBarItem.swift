//
//  TabBarItem.swift
//  RescuePets
//
//  Created by Michael do Prado on 10/22/21.
//

import Foundation
import SwiftUI

enum TabBarItem : Hashable {

    case notification, createStory, messages, profile
    
    var iconName : String {
        switch self {
        case .notification:
            return "iconNotify:Inactive"
        case .createStory:
            return "iconCamera:Inactive"
        case .messages:
            return "iconMessage:Inactive"
        case .profile:
            return "iconProfile:Inactive"
        }
    }
}
