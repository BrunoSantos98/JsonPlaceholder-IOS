//
//  SavedPostsView.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 03/01/26.
//

import SwiftUI
import SwiftData

struct SavedPostsView: View {
    
    @Query(sort: \SaveDataModel.savedAt, order: .reverse) var savedPosts: [SaveDataModel]
    @StateObject private var homePageVM = HomeScreenViewModel()
    let columns = [
        GridItem(.adaptive(minimum: 350), spacing: 16)
    ]
    
    var body: some View {
        ScrollView{
            if savedPosts.isEmpty {
                emptyStateView
            } else {
                contentListView
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle(Text("Saved Posts"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: PostHomePageModel.self) { post in
            PostScreenView(post: post)
        }
    }
}

private extension SavedPostsView {
    var contentListView: some View {
        LazyVGrid(columns: columns) {
            ForEach(savedPosts) { post in
                NavigationLink(value: PostHomePageModel(from: post)) {
                    HomeScreenCardView(cardPost: PostHomePageModel(from: post), image: homePageVM.loadImage(imageName: post.imageName))
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    var emptyStateView: some View {
        VStack {
            Image(systemName: "tray")
                .font(.largeTitle)
                .foregroundColor(.secondary)
                .padding(.bottom, 8)
            
            Text("Nothing to see here yet")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 400)
    }
}

#Preview {
    NavigationStack {
        SavedPostsView()
    }
}
