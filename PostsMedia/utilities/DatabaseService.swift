//
//  DatabaseService.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 03/01/26.
//

import SwiftData
import Foundation

class DatabaseService {
    static let instance = DatabaseService()
    
    private init(){}
    
    func isPostSaved(postId: Int, context: ModelContext) -> Bool{
        do{
            let descriptor = FetchDescriptor<SaveDataModel>(predicate: #Predicate{ $0.id == postId })
            let count = (try context.fetchCount(descriptor))
            return count > 0
        } catch let error{
            print("Error when try to save the post: \(error)")
            return false
        }
    }
    
    func savePost(_ post: PostHomePageModel, context: ModelContext){
        do{
            let saveDataModel = SaveDataModel(from: post)
            context.insert(saveDataModel)
            try context.save()
        } catch let error{
            print("Error when try to save the post: \(error)")
        }
    }
    
    func removePost(postId: Int, context: ModelContext){
        do{
            let descriptor = FetchDescriptor<SaveDataModel>(predicate: #Predicate{ $0.id == postId })
            if let objectToDelete = try context.fetch(descriptor).first {
                context.delete(objectToDelete)
                try context.save()
            }
        } catch let error{
            print("Error when try to delete the post: \(error)")
        }
    }
}
