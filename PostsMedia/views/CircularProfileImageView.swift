//
//  CircularProfileImageView.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 31/12/25.
//

import SwiftUI



struct CircularProfileImageView: View {
    
    let height: CGFloat
    let width: CGFloat
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .clipShape(Circle())
    }
}

#Preview {
    CircularProfileImageView(height: 48, width: 48, image: UIImage(named:"avatar-1") ?? UIImage())
}
