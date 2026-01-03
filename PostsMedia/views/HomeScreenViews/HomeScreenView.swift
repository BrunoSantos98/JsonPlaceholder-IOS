//
//  HomePageView.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 26/12/25.
//

import SwiftUI

struct HomeScreenView: View {
    
    @StateObject private var vm = HomeScreenViewModel()
    
    var body: some View {
        ScrollView {
            if vm.isLoading {
                loadingStateView
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

// MARK: - Subviews para organizar o código
private extension HomeScreenView {
    
    var contentListView: some View {
        LazyVStack {
            ForEach(vm.postsHomePage) { post in
                NavigationLink(value: post) {
                    HomeScreenCardView(cardPost: post, image: vm.loadImage(imageName: post.imageName))
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    var loadingStateView: some View {
        VStack(spacing: 0) {
            ForEach(0..<8, id: \.self) { _ in
                SkeletonRowView()
                Divider().padding(.leading, 16)
            }
        }
    }
    
    var emptyStateView: some View {
        VStack {
            Image(systemName: "tray")
                .font(.system(size: 50))
                .foregroundColor(.gray)
                .padding(.bottom, 8)
            
            Text("Sem posts no momento.")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Button("Tentar novamente") {
                vm.loadData()
            }
            .padding(.top)
        }
        .frame(maxWidth: .infinity, minHeight: 400)
    }
}

// MARK: - Componente Visual do Esqueleto
struct SkeletonRowView: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 8) {

                RoundedRectangle(cornerRadius: 4)
                    .frame(height: 14)
                    .frame(maxWidth: .infinity)
                
                RoundedRectangle(cornerRadius: 4)
                    .frame(height: 14)
                    .frame(width: 150)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .foregroundStyle(Color.gray.opacity(0.3))
        .opacity(isAnimating ? 0.3 : 1.0)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeScreenView()
    }
}
