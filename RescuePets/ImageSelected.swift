//
//  ImageSelected.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/24/21.
//

import SwiftUI
import UIKit

struct ImageSelected: Identifiable, Equatable{
    var id = UUID()
    var imageData: Data
    var image: Image
}
