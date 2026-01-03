//
//  SaveDataModel.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 03/01/26.
//

import SwiftData
import Foundation

@Model
class SaveDataModel{
    @Attribute(.unique) var id: Int
    var username: String
    var userTag: String
    var imageName: String
    var post: PostModel
    var savedAt: Date
    
    init(from apiPost: PostHomePageModel){
        self.id = apiPost.id
        self.username = apiPost.username
        self.userTag = apiPost.userTag
        self.imageName = apiPost.imageName
        self.post = apiPost.post
        self.savedAt = Date()
    }
}
