//
//  UserScreenViewModelTests.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 17/01/26.
//

import Foundation
import Testing
import SwiftData
import Combine
@testable import PostsMedia

@Suite("User Screen ViewModel Tests", .serialized)
@MainActor
struct UserScreenViewModelTests {
    var vm: UserScreenViewModel
    var service: PostsDataService
    
    init() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol.self]
        let session = URLSession(configuration: config)
        self.service = PostsDataService(urlSession: session)
        
        self.vm = UserScreenViewModel(postsService: service)
    }
    
    func mockUser() -> Data{
        do{
            let geo01 = Geo(
                lat: "-37.3159",
                lng: "81.1496"
            )
            
            let address01 = Address(
                street: "Kulas Light",
                suite: "Apt. 556",
                city: "Gwenborough",
                zipcode: "92998-3874",
                geo: geo01
            )
            
            let company01 = Company(
                name: "Romaguera-Crona",
                catchPhrase: "Multi-layered client-server neural-net",
                bs: "harness real-time e-markets"
            )
            
            let user01 = UserModel(
                id: 1,
                name: "Leanne Graham",
                username: "Bret",
                email: "Sincere@april.biz",
                address: address01,
                phone: "1-770-736-8031 x56442",
                website: "hildegard.org",
                company: company01
            )
            
            let geo02 = Geo(
                lat: "-43.9509",
                lng: "-34.4618"
            )
            
            let address02 = Address(
                street: "Victor Plains",
                suite: "Suite 879",
                city: "Wisokyburgh",
                zipcode: "90566-7771",
                geo: geo02
            )
            
            let company02 = Company(
                name: "Deckow-Crist",
                catchPhrase: "Proactive didactic contingency",
                bs: "synergize scalable supply-chains"
            )
            
            let user02 = UserModel(
                id: 2,
                name: "Ervin Howell",
                username: "Antonette",
                email: "Shanna@melissa.tv",
                address: address02,
                phone: "010-692-6593 x09125",
                website: "anastasia.net",
                company: company02
            )
            
            return try JSONEncoder().encode([user01, user02])
        } catch let error{
            print("Error when try to encode the user: \(error)")
            return Data()
        }
    }
    func mockTasks() -> Data{
        do{
            let tasks = [
                TodoTasks(userId: 1, id: 1, title: "delectus aut autem", completed: false),
                TodoTasks(userId: 1, id: 2, title: "quis ut nam facilis et officia qui", completed: false),
                TodoTasks(userId: 1, id: 3, title: "fugiat veniam minus", completed: false),
                TodoTasks(userId: 1, id: 4, title: "et porro tempora", completed: true),
                TodoTasks(userId: 1, id: 5, title: "laboriosam mollitia et enim quasi adipisci quia provident illum", completed: false),
                TodoTasks(userId: 1, id: 6, title: "qui ullam ratione quibusdam voluptatem quia omnis", completed: false)
            ]
            return try JSONEncoder().encode(tasks)
        } catch let error{
            print("Error when try to encode the tasks: \(error)")
            return Data()
        }
    }
    func mockRequest(statusCode: Int, data: Data) {
        MockUrlProtocol.requestHandler = { req in
            guard let safeUrl = req.url else { throw URLError(.badURL) }
            
            guard let response = HTTPURLResponse(
                url: safeUrl,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            ) else { throw URLError(.badServerResponse) }
            return (response, data)
        }
    }
    
    @Test("Initial state should have empty user")
    func testInitialUserState() {
        #expect(vm.user.id == 0)
        #expect(vm.user.name == "")
        #expect(vm.user.email == "")
        #expect(vm.user.username == "")
    }
    
    @Test("Initial state should have empty task list")
    func testInitialTaskListState() {
        #expect(vm.taskList.isEmpty)
    }
    
    @Test("Initial state should not be loading")
    func testInitialLoadingState() {
        #expect(vm.isLoading == false)
    }
    
    @Test("Initial state should have no error")
    func testInitialErrorState() {
        #expect(vm.errorMessage == nil)
    }
    
    @Test("Should find user and update UI")
    func testFetchUserSuccess() async throws {
        let user = mockUser()
        mockRequest(statusCode: 200, data: user)
        
        await confirmation("should be update user", expectedCount: 1){confirm in
            var cancellables = Set<AnyCancellable>()
            
            vm.$user
                .dropFirst()
                .sink{ receivedUser in
                    if(receivedUser.id == 1){
                        #expect(receivedUser.name == "Leanne Graham")
                        #expect(receivedUser.email == "Sincere@april.biz")
                        #expect(receivedUser.username == "Bret")
                        
                        confirm()
                    }
                }
                .store(in: &cancellables)
            
            await vm.fetchUser(userId: 1)
        }
        
        #expect(vm.isLoading == false)
        #expect(vm.errorMessage == nil)
    }
    
    @Test("Should fetch task and update UI")
    func testFetchTaskSuccess() async throws {
        let tasks = mockTasks()
        mockRequest(statusCode: 200, data: tasks)
        
        await confirmation("Should fetch tasks", expectedCount: 1){ confirm in
            var cancellables = Set<AnyCancellable>()
            
            vm.$taskList
                .dropFirst()
                .sink{ receivedTasks in
                    if(receivedTasks.count > 0){
                        #expect(receivedTasks.count == 6)
                        #expect(receivedTasks[0].title == "delectus aut autem")
                        #expect(receivedTasks[0].completed == false)
                        #expect(receivedTasks[3].completed == true)
                        #expect(receivedTasks[3].id == 4)
                        
                        confirm()
                    }
                }
                .store(in: &cancellables)
            
            await vm.fetchTodoTasks(userId: 1)
        }
        
        #expect(vm.isLoading == false)
        #expect(vm.errorMessage == nil)
    }
}
