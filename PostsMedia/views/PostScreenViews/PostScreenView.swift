//
//  PostPageView.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 01/01/26.
//

import SwiftUI

struct PostScreenView: View {
    
    let fileManager = LocalFileManagerServices.instance
    @StateObject private var vm = PostScreenViewModel()
    
    let post: PostHomePageModel
    
    var body: some View {
        
        
        
        ZStack{
            VStack(spacing: 0){
                Color("primaryBackground")
                Color(.secondarySystemBackground)
            }
            .ignoresSafeArea(edges: .all)
            
            ScrollView
            {
                headSection
                
                if vm.isLoading{
                    loadingComments
                } else {
                    commentsSection
                }
            }
            .navigationTitle(Text("Post"))
            .navigationBarTitleDisplayMode(.inline)
            .scrollBounceBehavior(.basedOnSize)
            .onAppear {
                vm.getComments(forPostId: post.post.id)
            }
        }
    }
}

private extension PostScreenView{
    
    var headSection: some View {
        VStack(alignment: .leading){
            HStack{
                NavigationLink(value: post.post.userId)
                {
                    UserResumedLineView(username: post.username, userTag: post.userTag, image: fileManager.loadImage(imageName: post.imageName))
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                ShareLink(item: vm.getTextToShare(post: post)){
                    Image(systemName: "square.and.arrow.up")
                        .font(.headline)
                }
            }
            .navigationDestination(for: Int.self){ userId in
                UserScreenView(userId: userId)
            }
            .padding(.bottom, 24)
            
            Text(post.post.title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 24)
            
            Text(post.post.body)
                .font(.headline)
                .fontWeight(.regular)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .background(Color("primaryBackground"))
    }
    
    var commentsSection: some View {
        VStack(alignment: .leading){
            HStack{
                Image(systemName: "bubble.left.fill")
                    .font(.title)
                Text("Comments (\(vm.postComments.count))")
                    .font(.title)
                    .fontWeight(.semibold)
            }
            if !vm.postComments.isEmpty{
                listOfComments
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top,24)
        .padding(.horizontal,24)
        .padding(.bottom, 24)
        .background(Color(.secondarySystemBackground))
    }
    
    var listOfComments: some View{
        StandardListView(itens: vm.postComments){ comment in
            VStack(alignment: .leading, spacing: 24){
                HStack(alignment: .top){
                    Image(systemName: "person.circle.fill")
                        .font(.title)
                    
                    VStack(alignment: .leading, spacing: 12){
                        Text(comment.email)
                            .font(.headline)
                        Text(comment.body)
                            .font(.subheadline)
                    }
                }
                .padding(.bottom, 8)
            }
            .padding(.vertical, 12)
            .background(Color("primaryBackground"))
        }
    }
    
    var loadingComments: some View{
        VStack(alignment: .leading){
            HStack{
                Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.icloud.fill")
                    .font(.title)
                    .padding(.trailing, 8)
                Text("Getting comments")
                    .font(.title)
                    .fontWeight(.semibold)
            }
            
            LoadingStateView(elements: 3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top,24)
        .padding(.horizontal,24)
        .padding(.bottom, 24)
        .background(Color(.secondarySystemBackground))
    }
}

#Preview {
    NavigationStack {
        PostScreenView(
            post: PostHomePageModel(id: 1, username: "Carlos Albert", userTag: "@Alberto",imageName: "avatar-1" ,post: PostModel(userId: 1, id: 1, title: "Aqui um título pequeno multilinha", body: "Um texto multiline aqui só para fazer uma demonstração basicoma mesmo sem muita enrolação"))
        )
    }
}
