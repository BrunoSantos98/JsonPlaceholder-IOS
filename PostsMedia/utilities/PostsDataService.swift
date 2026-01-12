//
//  PostsDataService.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 26/12/25.
//

import Foundation
import Combine

class PostsDataService: ObservableObject {
    
    static let instance = PostsDataService()
    
    private let fileManagerService = LocalFileManagerServices.instance
    private let urlSession: URLSession
    
    @Published var posts: [PostModel] = []
    @Published var postById: PostModel? = nil
    @Published var postComments: [PostCommentModel] = []
    @Published var users: [UserModel] = []
    @Published var userById: UserModel? = nil
    var cancellables = Set<AnyCancellable>()
    
    init(urlSession: URLSession = .shared){
        self.urlSession = urlSession
    }
    
    func getPosts(){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        self.urlSession.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: [PostModel].self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("Error when try to get posts: \(error)")
                    break
                case .finished:
                    break
                }
            } receiveValue: { [weak self] (receivedsPosts) in
                self?.posts = receivedsPosts
            }
            .store(in: &cancellables)
    }
    
    func getPostById(id: Int){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(id)") else { return }
        
        urlSession.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: PostModel.self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("Error when try to get post by ID: \(error)")
                    break
                case .finished:
                    break
                }
            } receiveValue: { [weak self] (receivedPost) in
                self?.postById = receivedPost
            }
            .store(in: &cancellables)
    }
    
    func getPostComments(postId: Int) async throws -> [PostCommentModel] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(postId)") else {
            throw URLError(.badURL)
        }
        
        do
        {
            let (data, response) = try await urlSession.data(from: url)
            
            try handleResponse(response: response, data: data)
            
            return try JSONDecoder().decode([PostCommentModel].self, from: data)
            
        } catch let error{
            print("Error when try to get comments: \(error)")
            return []
        }
    }
    
    func fetchUserById(userId: Int){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(userId)") else { return }
        
        urlSession.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: UserModel.self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("Error when try to get user by ID: \(error)")
                    break
                case .finished:
                    break
                }
            } receiveValue: { [weak self] (receivedUser) in
                self?.userById = receivedUser
            }
            .store(in: &cancellables)
    }

    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data{
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        
        return output.data
    }

    func handleResponse(response: URLResponse, data: Data) throws{
        guard
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
    }
    
    func getUsers(){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        urlSession.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: [UserModel].self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("Error when try to get users: \(error)")
                    break
                case .finished:
                    break
                }
            } receiveValue: { [weak self] (receivedsUsers) in
                self?.users = receivedsUsers
            }
            .store(in: &cancellables)
    }
        
    func getUserById(userId: Int) async throws -> UserModel {
        guard
            let url = URL(string: "https://jsonplaceholder.typicode.com/users?id=\(userId)") else {
            throw URLError(.badURL)
        }
        
        do{
            let(data, response) = try await urlSession.data(from: url)
            try handleResponse(response: response, data: data)
            
            let listUsers =  try JSONDecoder().decode([UserModel].self, from: data)
            guard let user = listUsers.first else {
                throw URLError(.cannotParseResponse)
            }
            
            return user
        }catch let error{
            print("Error when try to get user by id: \(error)")
            return UserModel()
        }
    }
        
    func getTasksByUserId(userId: Int) async throws -> [TodoTasks]{
        guard
            let url = URL(string: "https://jsonplaceholder.typicode.com/todos?userId=\(userId)") else {
            throw URLError(.badURL)
        }
        
        do{
            let(data, response) = try await urlSession.data(from: url)
            try handleResponse(response: response, data: data)
            
            return try JSONDecoder().decode([TodoTasks].self, from: data)
            
        }catch let error{
            print("Error when try to get user by id: \(error)")
            return []
        }
    }
    
}
