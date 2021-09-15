//
//  CommentCellViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 9/10/21.
//

import Combine
import SwiftUI

final class CommentCellViewModel : ObservableObject , Identifiable {
    
    @Published var comment : Comment
    private var cancellables = Set<AnyCancellable>()
    
    var id = ""
    var timestamp = ""
    var text = ""
    var from = ""
    
    init(comment: Comment) {
        self.comment = comment
        
        $comment.compactMap{ comment in
            comment.id
        }
        .weakAssign(to: \.id, on: self)
        .store(in: &cancellables)
        
        $comment.compactMap{ comment in
            comment.text
        }
        .weakAssign(to: \.text, on: self)
        .store(in: &cancellables)
        
        $comment.compactMap{ comment in
            comment.from
        }
        .weakAssign(to: \.from, on: self)
        .store(in: &cancellables)
        
        $comment.compactMap { comment in
            Timestamp.setupTimeStamp(time: comment.timestamp)
        }
        .weakAssign(to: \.timestamp, on: self)
        .store(in: &cancellables)
        
    }
    
}
