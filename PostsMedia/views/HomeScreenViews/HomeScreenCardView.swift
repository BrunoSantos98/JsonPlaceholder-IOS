//
//  HomePageCardView.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 26/12/25.
//

import SwiftUI

struct HomeScreenCardView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var postVM = PostScreenViewModel()
    
    let cardPost: PostHomePageModel
    let image: UIImage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            HStack{
                UserResumedLineView(username: cardPost.username, userTag: cardPost.userTag, image: image)
                
                Spacer()
                
                Button {
                    withAnimation(.bouncy(duration: 0.5, extraBounce: 0.4)){
                        postVM.toggleSaveStatus(post: cardPost)
                    }
                    } label: {
                            Image(systemName: postVM.isSaved ? "bookmark.fill" : "bookmark")
                                .font(.title)
                    }
                    .accessibilityLabel(postVM.isSaved ? "Remove post from saved posts" : "Save post")
                    .accessibilityHint("Click to save or remove this post from your saved posts")
                }
                
                Text(cardPost.post.title)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(cardPost.post.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                Spacer(minLength: 0)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: 200)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("primaryBackground"))
                    .strokeBorder(Color("primaryBackgroundContrast").opacity(0.1), lineWidth: 1)
                    .shadow(color: Color("primaryBackgroundContrast").opacity(0.3), radius: 8)
            )
            .onAppear{
                postVM.setupDatabase(context: context, postId: cardPost.post.id)
            }
        }
    }
    
    
    #Preview(traits: .sizeThatFitsLayout) {
        HomeScreenCardView(cardPost: PostHomePageModel(id: 1, username: "Carlos Albert", userTag: "@Alberto",imageName: "avatar-1" ,post: PostModel(userId: 1, id: 1, title: "Aqui um título pequeno multilinha", body: "Um texto multiline aqui só para fazer uma demonstração basicoma mesmo sem muita enrolação")), image:UIImage(named: "avatar-1") ?? UIImage())
    }
