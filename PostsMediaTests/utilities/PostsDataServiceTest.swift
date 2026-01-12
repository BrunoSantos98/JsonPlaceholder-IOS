//
//  PostsDataServiceTest.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 06/01/26.
//

import Testing
import Foundation
import Combine
@testable import PostsMedia

@Suite("Post Data service (network test)", .serialized)
struct PostsDataServiceTest {
    
    func createService() -> PostsDataService {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockUrlProtocol.self]
        let mockSession = URLSession(configuration: configuration)
        return PostsDataService(urlSession: mockSession)
    }
    
    func makeUrlResponse(for url: URL?, statusCode: Int = 200) throws -> HTTPURLResponse {
        let validURL = try #require(url, "URL can't be nil")
        
        let response = HTTPURLResponse(
            url: validURL,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
        
        return try #require(response, "Fail when try to create HTTPURLResponse")
    }
    
    func mockUserList() -> [UserModel]{
        let firstUserJson = """
            {
                "id": 1,
                "name": "Leanne Graham",
                "username": "Bret",
                "email": "Sincere@april.biz",
                "address": {
                  "street": "Kulas Light",
                  "suite": "Apt. 556",
                  "city": "Gwenborough",
                  "zipcode": "92998-3874",
                  "geo": {
                    "lat": "-37.3159",
                    "lng": "81.1496"
                  }
                },
                "phone": "1-770-736-8031 x56442",
                "website": "hildegard.org",
                "company": {
                  "name": "Romaguera-Crona",
                  "catchPhrase": "Multi-layered client-server neural-net",
                  "bs": "harness real-time e-markets"
                }
              }
            """
        let secondUserJson = """
            {
              "id": 2,
              "name": "Ervin Howell",
              "username": "Antonette",
              "email": "Shanna@melissa.tv",
              "address": {
                "street": "Victor Plains",
                "suite": "Suite 879",
                "city": "Wisokyburgh",
                "zipcode": "90566-7771",
                "geo": {
                  "lat": "-43.9509",
                  "lng": "-34.4618"
                }
              },
              "phone": "010-692-6593 x09125",
              "website": "anastasia.net",
              "company": {
                "name": "Deckow-Crist",
                "catchPhrase": "Proactive didactic contingency",
                "bs": "synergize scalable supply-chains"
              }
            }
            """
        guard
            let jsonFirstData =  firstUserJson.data(using: .utf8),
            let jsonSecondData =  secondUserJson.data(using: .utf8)
        else{ return [] }
        
        do
        {
            let firstUser: UserModel = try JSONDecoder().decode(UserModel.self, from: jsonFirstData)
            let secondUser: UserModel = try JSONDecoder().decode(UserModel.self, from: jsonSecondData)
            
            return [firstUser, secondUser]
        } catch{
            return []
        }
    }
    // MARK: - Testes de variáveis @Published
    
    @Test("Should fetch posts")
    func fetchPostsTest() async throws {
        let service = createService()
        
        let mockPosts = [
            PostModel(userId: 1, id: 1, title: "Test Post 1", body: "Body 1"),
            PostModel(userId: 1, id: 2, title: "Test Post 2", body: "Body 2")
        ]
        
        let jsonPostMocked = try JSONEncoder().encode(mockPosts)
        
        MockUrlProtocol.requestHandler = { req in
            let response = try self.makeUrlResponse(for: req.url)
            return (response, jsonPostMocked)
        }
        
        let receivedPosts = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[PostModel], Error>) in
            var cancellable: AnyCancellable?
            
            cancellable = service.$posts
                .dropFirst()
                .first(where: { $0.count == 2 })
                .sink { posts in
                    continuation.resume(returning: posts)
                    cancellable?.cancel()
                }
            
            service.getPosts()
        }
        
        #expect(receivedPosts.count == 2)
        #expect(receivedPosts[0].title == "Test Post 1")
        #expect(receivedPosts[1].title == "Test Post 2")
    }
    
    @Test("Should fetch post by id")
    func fetchPostByIdTest() async throws {
        let service = createService()
        
        let mockPost = PostModel(userId: 1, id: 5, title: "Specific Post", body: "Specific Body")
        let jsonPostMocked = try JSONEncoder().encode(mockPost)
        
        MockUrlProtocol.requestHandler = { req in
            let response = try self.makeUrlResponse(for: req.url)
            return (response, jsonPostMocked)
        }
        
        let receivedPost = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<PostModel, Error>) in
            var cancellable: AnyCancellable?
            
            cancellable = service.$postById
                .dropFirst()
                .compactMap { $0 }
                .first()
                .sink { post in
                    continuation.resume(returning: post)
                    cancellable?.cancel()
                }
            
            service.getPostById(id: 5)
        }
        
        #expect(receivedPost.id == 5)
        #expect(receivedPost.title == "Specific Post")
    }
    
    @Test("Should fetch users")
    func fetchUsersTest() async throws {
        let service = createService()
        
        let mockUsers = mockUserList()
        let jsonUsersMocked = try JSONEncoder().encode(mockUsers)
        
        MockUrlProtocol.requestHandler = { req in
            let response = try self.makeUrlResponse(for: req.url)
            return (response, jsonUsersMocked)
        }
        
        let receivedUsers = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[UserModel], Error>) in
            var cancellable: AnyCancellable?
            
            cancellable = service.$users
                .dropFirst()
                .first(where: { $0.count == 2 })
                .sink { users in
                    continuation.resume(returning: users)
                    cancellable?.cancel()
                }
            
            service.getUsers()
        }
        
        #expect(receivedUsers.count == 2)
        #expect(receivedUsers[0].name == "Leanne Graham")
        #expect(receivedUsers[1].username == "Antonette")
    }
    
    @Test("Should fetch user by id (Combine)")
    func fetchUserByIdCombineTest() async throws {
        let service = createService()
        
        let mockUsers = mockUserList()
        let jsonUserMocked = try JSONEncoder().encode(mockUsers[1])
        
        MockUrlProtocol.requestHandler = { req in
            let response = try self.makeUrlResponse(for: req.url)
            return (response, jsonUserMocked)
        }
        
        let receivedUser = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<UserModel, Error>) in
            var cancellable: AnyCancellable?
            
            cancellable = service.$userById
                .dropFirst()
                .compactMap { $0 }
                .first()
                .sink { user in
                    continuation.resume(returning: user)
                    cancellable?.cancel()
                }
            
            service.fetchUserById(userId: 2)
            
        }
        
        #expect(receivedUser.id == 2)
        #expect(receivedUser.name == "Ervin Howell")
    }
    
    // MARK: - Testes de métodos async/await
    
    @Test("Should fetch post comments")
    func fetchPostCommentsTest() async throws {
        let service = createService()
        
        let mockComments = [
            PostCommentModel(postId: 3, id: 1, name: "Comment 1", email: "test1@test.com", body: "Body 1"),
            PostCommentModel(postId: 3, id: 2, name: "Comment 2", email: "test2@test.com", body: "Body 2")
        ]
        
        let jsonCommentsMocked = try JSONEncoder().encode(mockComments)
        
        MockUrlProtocol.requestHandler = { req in
            let response = try self.makeUrlResponse(for: req.url)
            return (response, jsonCommentsMocked)
        }
        
        let comments = try await service.getPostComments(postId: 3)
        
        #expect(comments.count == 2)
        #expect(comments[0].name == "Comment 1")
        #expect(comments[1].email == "test2@test.com")
    }
    
    @Test("Should fetch user by id (async)")
    func fetchUserByIdAsyncTest() async throws {
        let service = createService()
        
        let mockUsers = mockUserList()
        let jsonUserMocked = try JSONEncoder().encode(mockUsers)
        
        MockUrlProtocol.requestHandler = { req in
            let response = try self.makeUrlResponse(for: req.url)
            return (response, jsonUserMocked)
        }
        
        let user = try await service.getUserById(userId: 1)
        
        #expect(user.id == 1)
        #expect(user.name == "Leanne Graham")
        #expect(user.username == "Bret")
    }
    
    @Test("Should fetch tasks by user id")
    func fetchTasksByUserIdTest() async throws {
        let service = createService()
        
        let mockTasks = [
            TodoTasks(userId: 3, id: 1, title: "Task 1", completed: false),
            TodoTasks(userId: 3, id: 2, title: "Task 2", completed: true)
        ]
        
        let jsonTasksMocked = try JSONEncoder().encode(mockTasks)
        
        MockUrlProtocol.requestHandler = { req in
            let response = try self.makeUrlResponse(for: req.url)
            return (response, jsonTasksMocked)
        }
        
        let tasks = try await service.getTasksByUserId(userId: 3)
        
        #expect(tasks.count == 2)
        #expect(tasks[0].title == "Task 1")
        #expect(tasks[0].completed == false)
        #expect(tasks[1].completed == true)
    }
    
    // MARK: - Testes de erro
    
    @Test("Should handle network error on getPosts")
    func handleNetworkErrorTest() async throws {
        let service = createService()
        
        MockUrlProtocol.requestHandler = { req in
            throw URLError(.notConnectedToInternet)
        }
        
        service.getPosts()
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        #expect(service.posts.isEmpty)
    }
    
    @Test("Should return empty array on getPostComments error")
    func handlePostCommentsErrorTest() async throws {
        let service = createService()
        
        MockUrlProtocol.requestHandler = { req in
            throw URLError(.badServerResponse)
        }
        
        let comments = try await service.getPostComments(postId: 5)
        
        #expect(comments.isEmpty)
    }
    
    @Test("Should handle invalid response status code")
    func handleInvalidStatusCodeTest() async throws {
        let service = createService()
        
        MockUrlProtocol.requestHandler = { req in
            let response = try self.makeUrlResponse(for: req.url, statusCode: 404)
            return (response, Data())
        }
        
        service.getPosts()
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        #expect(service.posts.isEmpty)
    }
}

// MARK: - Mock URLProtocol

class MockUrlProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = Self.requestHandler else {
            fatalError("No request handler set.")
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}
