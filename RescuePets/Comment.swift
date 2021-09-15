//
//  Comment.swift
//  RescuePets
//
//  Created by Michael do Prado on 9/9/21.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Comment: Codable, Identifiable {

    @DocumentID var id: String?
    var from: String
    var text: String
    var timestamp: Int
    
}
