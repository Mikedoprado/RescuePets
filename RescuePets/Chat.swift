//
//  Chat.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/23/21.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import MapKit

struct Chat : Codable, Identifiable {
    
    @DocumentID var id: String?
    var owners : [String]
    var timestamp: Int
    var lastComment: String?
    var isReaded: [String : Bool]
    
}
