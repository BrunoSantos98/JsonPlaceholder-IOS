//
//  HomePageUserDetailLineView.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 26/12/25.
//

import SwiftUI

struct UserResumedLineView: View {
    
    let username: String
    let userTag: String
    let image: UIImage
    @ScaledMetric(relativeTo: .body) var tamanhoAvatar: CGFloat = 48
    
    var body: some View {
        HStack{
            CircularProfileImageView(height: tamanhoAvatar, width: tamanhoAvatar, image: image)
            
            VStack(alignment: .leading){
                Text(username)
                    .font(.headline)
                Text(userTag)
                    .font(.subheadline)
            }
            .padding(.leading ,16)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    UserResumedLineView(username: "Carlos Albert", userTag: "@Alberto", image: UIImage(named:"avatar-1") ?? UIImage())
}
