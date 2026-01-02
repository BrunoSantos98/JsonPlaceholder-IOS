//
//  HomePageView.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 26/12/25.
//

import SwiftUI
import Combine

// MARK: ViewModel

class PostsDataService: ObservableObject {
    
    @Published var posts: [PostModel] = []
    @Published var postById: PostModel? = nil
    @Published var users: [UserModel] = []
    @Published var userById: UserModel? = nil
    var cancellables = Set<AnyCancellable>()
    
    init(){}
    
    func getPosts(){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: [PostModel].self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("Erro ao tentar buscar os dados: \(error)")
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
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: PostModel.self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("Erro ao tentar buscar os dados: \(error)")
                    break
                case .finished:
                    break
                }
            } receiveValue: { [weak self] (receivedPost) in
                self?.postById = receivedPost
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
    
    func getUsers(){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: [UserModel].self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("Erro ao tentar buscar os dados: \(error)")
                    break
                case .finished:
                    break
                }
            } receiveValue: { [weak self] (receivedsUsers) in
                self?.users = receivedsUsers
            }
            .store(in: &cancellables)
    }
    
    func getUserById(id: Int){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(id)") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: UserModel.self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("Erro ao tentar buscar os dados: \(error)")
                    break
                case .finished:
                    break
                }
            } receiveValue: { [weak self] (receivedUser) in
                self?.userById = receivedUser
            }
            .store(in: &cancellables)
    }
}

// MARK: Views

struct HomePageView: View {
    
    let username: String = "Nome usuario"
    let userTag: String = "@usuario"
    let post = PostModel(userId: 1, id: 1, title: "Título do post", body: "Esse é um texto do post onde ele será jultilinha eu tenho que fazer um texto bem grande que e para eu poder verificar corretamente como vai ficar na tela.")
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    ForEach(0..<4){posts in
                        HomePageCardView(username: username, userTag: userTag, post: post)
                    }
                }
            }
        }
    }
}

struct HomePageUserDetailLineView: View {
    
    let username: String
    let userTag: String
    
    var body: some View {
        HStack{
            Circle()
                .frame(width: 42, height: 42)
            
            VStack(alignment: .leading){
                Text(username)
                    .font(.headline)
                Text(userTag)
                    .font(.subheadline)
            }
            .padding(.leading ,16)
        }
    }
}

#Preview {
    HomePageView()
}
