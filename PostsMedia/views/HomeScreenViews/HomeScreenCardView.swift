//
//  HomePageCardView.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 26/12/25.
//

import SwiftUI

struct HomeScreenCardView: View {
    let cardPost: PostHomePageModel
    let image: UIImage
    
    var body: some View {
            VStack(alignment: .leading, spacing: 12){
                UserResumedLineView(username: cardPost.username, userTag: cardPost.userTag, image: image)
                
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
            .frame(height: 200)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("primaryBackground"))
                    .strokeBorder(Color("primaryBackgroundContrast").opacity(0.1), lineWidth: 1)
                    .shadow(color: Color("primaryBackgroundContrast").opacity(0.3), radius: 8)
            )
    }
}


#Preview(traits: .sizeThatFitsLayout) {
    HomeScreenCardView(cardPost: PostHomePageModel(id: 1, username: "Carlos Albert", userTag: "@Alberto",imageName: "avatar-1" ,post: PostModel(userId: 1, id: 1, title: "Aqui um título pequeno multilinha", body: "Um texto multiline aqui só para fazer uma demonstração basicoma mesmo sem muita enrolação")), image:UIImage(named: "avatar-1") ?? UIImage())
}
