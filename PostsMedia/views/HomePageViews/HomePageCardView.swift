//
//  HomePageCardView.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 26/12/25.
//

import SwiftUI

struct HomePageCardView: View {
    let cardPost: PostHomePageModel
    let image: UIImage
    
    var body: some View {
        ZStack(alignment: .leading){
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("primaryBackground"))
                .strokeBorder(Color("primaryBackgroundContrast").opacity(0.1), lineWidth: 1)
                .shadow(color: Color("primaryBackgroundContrast").opacity(0.3), radius: 8)
                .frame(maxWidth: .infinity)
                .padding(.horizontal ,32)
                .padding(.vertical ,16)
                .aspectRatio(1.5, contentMode: .fit)
            
            VStack(alignment: .leading, spacing: 18){
                HomePageUserDetailLineView(username: cardPost.username, userTag: cardPost.userTag, image: image)
                
                Text(cardPost.post.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(cardPost.post.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .padding(.horizontal ,56)
        }
    }
}


#Preview(traits: .sizeThatFitsLayout) {
    HomePageCardView(cardPost: PostHomePageModel(id: 1, username: "Carlos Albert", userTag: "@Alberto",imageName: "avatar-1" ,post: PostModel(userId: 1, id: 1, title: "Aqui um título pequeno multilinha", body: "Um texto multiline aqui só para fazer uma demonstração basicoma mesmo sem muita enrolação")), image:UIImage(named: "avatar-1") ?? UIImage())
}
