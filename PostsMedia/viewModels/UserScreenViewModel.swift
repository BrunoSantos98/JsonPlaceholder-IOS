//
//  UserScreenViewModel.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 02/01/26.
//

import Foundation
import SwiftUI

@MainActor
class UserScreenViewModel: ObservableObject{
    
    private let postsService = PostsDataService.instance
    private let fileManagerService = LocalFileManagerServices.instance
    
    @Published var user: UserModel = UserModel()
    @Published var taskList: [TodoTasks] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    func fetchUser(userId: Int) {
        
        self.errorMessage = nil
        self.isLoading = true
        
        Task{
            do{
                let fetchedUser = try await postsService.getUserById(userId: userId)
                
                self.user = fetchedUser
                self.isLoading = false
            } catch let error{
                self.errorMessage = "Ocorreu um erro: \(error.localizedDescription)"
                if let errorMsg = self.errorMessage {
                    print(errorMsg)
                }
                print("Error when try to fetch user with id: \(userId) -> \(error)")
            }
        }
    }
    
    func fetchTodoTasks(userId: Int){
        self.errorMessage = nil
        self.isLoading = true
        
        Task{
            do{
                let fetchedTasks = try await postsService.getTasksByUserId(userId: userId)
                
                self.taskList = fetchedTasks
                self.isLoading = false
            }catch let error{
                self.errorMessage = "Ocorreu um erro: \(error.localizedDescription)"
                if let errorMsg = self.errorMessage {
                    print(errorMsg)
                }
                print("Error when try to fetch user with id: \(userId) -> \(error)")
            }
        }
    }
    
    func loadImage(imageName: String) -> UIImage{
        return fileManagerService.loadImage(imageName: imageName)
    }
}
