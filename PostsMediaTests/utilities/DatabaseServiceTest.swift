//
//  DatabaseServiceTest.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 06/01/26.
//

import Testing
import SwiftData
import Foundation
@testable import PostsMedia

@Suite("Database Tests")
struct DatabaseServiceTest {

    let service = DatabaseService.instance
    let container: ModelContainer
    let context: ModelContext
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        
        self.container = try ModelContainer(for: SaveDataModel.self, configurations: config)
        self.context = ModelContext(container)
    }
    
    @Test("Should save a post")
    func savePostTest() throws{
        let post = PostModel(userId: 1, id: 1, title: "Teste", body: "Corpo")
        let postHomePage = PostHomePageModel(id: 1, username: "John", userTag: "@JJ", imageName: "avatar-1", post: post)
        
        service.savePost(postHomePage, context: context)
        
        let fetchedPost = try context.fetch(FetchDescriptor<SaveDataModel>())
        
        #expect(fetchedPost.count == 1)
        #expect(fetchedPost.first?.id == 1)
    }
    
    @Test("Should Verify post is saved")
    func isPostSavedTest() throws{
        let post = PostModel(userId: 99, id: 99, title: "save?", body: "Is saved")
        let postHomePage = PostHomePageModel(id: 99, username: "Justin", userTag: "@JB", imageName: "avatar-9", post: post)
        service.savePost(postHomePage, context: context)
        
        let isSaved = service.isPostSaved(postId: post.id, context: context)
        let isNotSaved = service.isPostSaved(postId: 100, context: context)
        
        #expect(isSaved, "Should be find a saved post ID 99")
        #expect(isNotSaved == false, "Should not find inexistent post")
    }
    
    @Test("Should be delete a post")
    func deletePostTest() async throws {
        let post = PostModel(userId: 50, id: 50, title: "delete?", body: "Is saved to delete")
        let postHomePage = PostHomePageModel(id: 50, username: "Deborah", userTag: "@DF", imageName: "avatar-5", post: post)
        service.savePost(postHomePage, context: context)
        
        #expect(service.isPostSaved(postId: post.id, context: context))
        
        service.removePost(postId: post.id, context: context)
        let isNotSavedAnymore = service.isPostSaved(postId: post.id, context: context)
        
        #expect(isNotSavedAnymore == false)
    }
    
    @Test("Should be update same ID (Upsert)")
    func updatePostTest() async throws {
        let post = PostModel(userId: 99, id: 101, title: "update?", body: "Lets update a post")
        let postHomePage = PostHomePageModel(id: 101, username: "Frank", userTag: "@FS", imageName: "avatar-1", post: post)
        service.savePost(postHomePage, context: context)
        
        let secondPost = PostModel(userId: 99, id: 101, title: "We updated the post", body: "And now it has been updated")
        let secondPostHomePage = PostHomePageModel(id: 101, username: "Franklin", userTag: "@FS", imageName: "avatar-1", post: secondPost)
        service.savePost(secondPostHomePage, context: context)
        
        let result = try context.fetch(FetchDescriptor<SaveDataModel>(predicate: #Predicate{ $0.id == post.id } ))
        
        #expect(result.count == 1, "Shouldn't duplicate the posts with same ID")
        #expect(result.first?.username == "Franklin", "The username should be updated")
        #expect(result.first?.post.title == "We updated the post", "The title should be updated")
        #expect(result.first?.post.body == "And now it has been updated", "The body should be updated")
    }
    
    @Test("Should not crash when try to delete inexistent post")
    func deleteNonExistentPostTest() async throws {
        service.removePost(postId: 2, context: context)
    }
}
