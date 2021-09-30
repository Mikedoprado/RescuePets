//
//  CommentViewModel.swift
//  RescuePets
//
//  Created by Michael do Prado on 9/10/21.
//

import Combine
import SwiftUI

final class CommentViewModel: CommentHelper ,ObservableObject {
    
    var commentRepository : CommentRepository?
    @Published var commentsCellViewModel : [CommentCellViewModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(storyId: String) {
        load(storyId)
    }
    
    func load(_ storyId: String) {
        
        commentRepository = CommentRepository(storyId: storyId)
        
        commentRepository?.$comments
            .sink(receiveValue: { [weak self] (comments) in
                    self?.commentsCellViewModel = comments.map { comment in
                        return CommentCellViewModel(comment: comment)
                    }
            })
            .store(in: &cancellables)
    }
    
    func add(_ comment: Comment, storyId: String) {
        self.commentRepository?.add(comment, storyId: storyId)
    }
    
    func remove(_ comment: Comment, storyId: String) {
        self.commentRepository?.remove(comment, storyId: storyId)
    }
    
    deinit{
        print("deinit CommentViewModel")
    }
}
