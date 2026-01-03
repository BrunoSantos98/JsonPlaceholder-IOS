//
//  PostPageViewModel.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 01/01/26.
//

import Foundation
import SwiftData

class PostScreenViewModel: ObservableObject {
    private let postsService = PostsDataService.instance
    private var modelContext: ModelContext?
    
    @Published var postComments: [PostCommentModel] = []
    @Published var isLoading: Bool = false
    @Published var isSaved: Bool = false
    
    init(){}
    
    func getComments(forPostId postId: Int) {
        isLoading = true
        Task{
            do{
                let receivedComments = try await postsService.getPostComments(postId: postId)
                
                await MainActor.run {
                    isLoading = false
                    self.postComments = receivedComments
                }
            } catch let error{
                print("Error when try to populate comments from post id: \(postId) -> \(error)")
            }
        }
    }
    
    func getTextToShare(post: PostHomePageModel) -> String {
        return "💬 See the last post from \(post.username)\n\n\(post.post.title)\n\n\(post.post.body)"
    }
    
    func setupDatabase(context: ModelContext, postId: Int){
        self.modelContext = context
        checkIfSaved(postId: postId)
    }
    
    func toggleSaveStatus(post: PostHomePageModel){
        guard let context = modelContext else {
            print("Failure when try to verify saved data")
            return
        }
        
        if isSaved{
            DatabaseService.instance.removePost(postId: post.id, context: context)
            isSaved = false
        } else {
            DatabaseService.instance.savePost(post, context: context)
            isSaved = true
        }
    }
    
    private func checkIfSaved(postId: Int){
        guard let context = modelContext else {
            print("Failure when try to verify saved data")
            return
        }
        self.isSaved = DatabaseService.instance.isPostSaved(postId: postId, context: context)
    }
}
