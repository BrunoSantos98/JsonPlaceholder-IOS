//
//  PostPageViewModel.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 01/01/26.
//

import Foundation

class PostPageViewModel: ObservableObject {
    private let postsService = PostsDataService.instance
    
    @Published var postComments: [PostCommentModel] = []
    
    init(){}
    
    func getComments(forPostId postId: Int) {
        Task{
            do{
                let receivedComments = try await postsService.getPostComments(postId: postId)
                
                await MainActor.run {
                    self.postComments = receivedComments
                }
            } catch let error{
                print("Error when try to populate comments from post id: \(postId) -> \(error)")
            }
        }
    }
    
    func getTextToShare(post: PostHomePageModel) -> String {
        return "💬 See the last post from \(post.username)\n\n\(post.post.title)\n\(post.post.body)"
    }
}
