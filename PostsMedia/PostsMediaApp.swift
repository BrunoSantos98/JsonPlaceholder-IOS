//
//  PostsMediaApp.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 26/12/25.
//

import SwiftUI
import SwiftData

@main
struct PostsMediaApp: App {
    var body: some Scene {
        WindowGroup {
            MainAppView()
        }
        .modelContainer(for: SaveDataModel.self)
    }
}
