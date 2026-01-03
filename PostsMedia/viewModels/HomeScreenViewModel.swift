//
//  HomePageViewModel.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 26/12/25.
//

import Foundation
import Combine
import SwiftUI

class HomeScreenViewModel: ObservableObject {
    private let postsService = PostsDataService.instance
    private let fileManagerService = LocalFileManagerServices.instance
    
    @Published var postsHomePage: [PostHomePageModel] = []
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
        saveImagesWhenInit()
    }
    
    private func addSubscribers(){
        Publishers.CombineLatest(postsService.$posts, postsService.$users)
            .map {(posts, users) -> [PostHomePageModel] in
                var tempPosts: [PostHomePageModel] = []
                
                for post in posts{
                    guard let foundedUser = users.first(where: { $0.id == post.userId }) else { continue }
                    
                    let newPost = PostHomePageModel(
                        id: post.id,
                        username: foundedUser.name,
                        userTag: "@" + foundedUser.username,
                        imageName: "avatar-\(post.userId)",
                        post: post
                    )
                    
                    tempPosts.append(newPost)
                }
                
                return tempPosts
            }
            .sink{ [weak self] (returnedPosts) in
                self?.postsHomePage = returnedPosts
                self?.isLoading = false            
            }
            .store(in: &cancellables)
    }
    
    private func saveImagesWhenInit(){
        let imageNames = ["avatar-1", "avatar-2", "avatar-3", "avatar-4", "avatar-5",
                              "avatar-6", "avatar-7", "avatar-8", "avatar-9", "avatar-10",]
        
        imageNames.forEach { imageName in
            if let imagem = UIImage(named: imageName){
                let response = fileManagerService.saveImage(image: imagem, name: imageName)
                print("Image \(imageName) response: \(response)")
            }
        }
    }
    
    func loadData(){
        isLoading = true
        postsService.getPosts()
        postsService.getUsers()
    }
    
    func loadImage(imageName: String) -> UIImage{
        return fileManagerService.loadImage(imageName: imageName)
    }
}
