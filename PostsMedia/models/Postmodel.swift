//
//  Postmodel.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 26/12/25.
//

import Foundation
import SwiftUI

struct PostModel: Identifiable, Codable, Hashable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct PostCommentModel: Identifiable, Codable, Hashable{
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}

struct PostHomePageModel: Identifiable, Codable, Hashable{
    
    let id: Int
    let username: String
    let userTag: String
    let imageName: String
    let post: PostModel
}
