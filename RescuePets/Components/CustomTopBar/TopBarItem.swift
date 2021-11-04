//
//  TopBarItem.swift
//  RescuePets
//
//  Created by Michael do Prado on 10/22/21.
//

import Foundation

import Foundation
import SwiftUI

enum TopBarItem : Hashable {
    
    case general, accepted, created
    
    var title : String {
        switch self{
        case .general:
            return "General"
        case .accepted:
            return "Accepted"
        case .created:
            return "Created"
        }
    }
}
