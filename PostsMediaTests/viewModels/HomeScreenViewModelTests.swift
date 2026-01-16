//
//  HomeScreenViewModelTests.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 16/01/26.
//

import Testing
import Combine
import Foundation
@testable import PostsMedia

@Suite("HomeScreenViewModel Test", .serialized)
@MainActor
struct HomeScreenViewModelTests {
    var vm: HomeScreenViewModel
    var service: PostsDataService
    
    init(){
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol.self]
        let mockSession = URLSession(configuration: config)
        
        self.service = PostsDataService(urlSession: mockSession)
        self.vm = HomeScreenViewModel(postService: service)
    }
    
    func mockPost() -> PostModel{
        return PostModel(userId: 1, id: 100, title: "Post title", body: "post body")
    }
    
    func mockUser() -> UserModel{
            let geo = Geo(
                lat: "-37.3159",
                lng: "81.1496"
            )
            
            let address = Address(
                street: "Kulas Light",
                suite: "Apt. 556",
                city: "Gwenborough",
                zipcode: "92998-3874",
                geo: geo
            )
            
            let company = Company(
                name: "Romaguera-Crona",
                catchPhrase: "Multi-layered client-server neural-net",
                bs: "harness real-time e-markets"
            )
            
            return UserModel(
                id: 1,
                name: "Leanne Graham",
                username: "Bret",
                email: "Sincere@april.biz",
                address: address,
                phone: "1-770-736-8031 x56442",
                website: "hildegard.org",
                company: company
            )
    }
    
    @Test("Should match post and user correctly")
    func testCombineMatchSuccess() async {
        let post = mockPost()
        let user = mockUser()
        
        await confirmation("Processing combine", expectedCount: 1) { confirm in
            var cancellables = Set<AnyCancellable>()
            
            vm.$postsHomePage
                .dropFirst()
                .sink{models in
                    if !models.isEmpty{
                        let model = models.first!
                        #expect(model.id == post.id)
                        #expect(model.post.userId == post.userId)
                        #expect(model.post.title == post.title)
                        #expect(model.post.body == post.body)
                        #expect(model.username == user.name)
                        
                        confirm()
                    }
                }
                .store(in: &cancellables)
            
            service.posts.append(post)
            service.users.append(user)
        }
    }
    
    @Test("Should not create post if user is not found")
    func textCombineMissingUser() async {
        let post = PostModel(userId: 10, id: 100, title: "Post title", body: "post body")
        let user = mockUser()
        
        await confirmation("Should update with an empty list", expectedCount: 2){ confirm in
            var cancellables = Set<AnyCancellable>()
            
            vm.$postsHomePage
                .dropFirst()
                .sink{ models in
                    #expect(models.isEmpty, "Should not create with non existing user")
                    confirm()
                }
                .store(in: &cancellables)
            
            service.posts.append(post)
            service.users.append(user)
        }
    }
}
