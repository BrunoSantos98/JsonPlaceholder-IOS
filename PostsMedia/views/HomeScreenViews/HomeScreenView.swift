//
//  HomePageView.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 26/12/25.
//

import SwiftUI

struct HomeScreenView: View {
    
    @StateObject private var vm = HomeScreenViewModel()
    let columns = [
        GridItem(.adaptive(minimum: 350), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            if vm.isLoading {
                LoadingStateView(elements: 8)
            } else if vm.postsHomePage.isEmpty {
                emptyStateView
            } else {
                contentListView
            }
        }
        .onAppear {
            vm.loadData()
        }
        .navigationDestination(for: PostHomePageModel.self) { post in
            PostScreenView(post: post)
        }
    }
}

// MARK: - Subviews
private extension HomeScreenView {
    
    var contentListView: some View {
        LazyVGrid(columns: columns) {
            ForEach(vm.postsHomePage) { post in
                NavigationLink(value: post) {
                    HomeScreenCardView(cardPost: post, image: vm.loadImage(imageName: post.imageName))
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
            
            Button("Try again") {
                vm.loadData()
            }
            .padding(.top)
        }
        .frame(maxWidth: .infinity, minHeight: 400)
    }
}

#Preview {
    NavigationStack {
        HomeScreenView()
    }
}
