//
//  Message.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/22/21.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Message: Codable, Identifiable {

    @DocumentID var id: String?
    var from: String
    var to: String
    var text: String
    var timestamp: Int
    
}
