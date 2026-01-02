//
//  HomePageView.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 26/12/25.
//

import SwiftUI

struct HomePageView: View {
    
    @StateObject private var vm = HomePageViewModel()
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    ForEach(vm.postsHomePage){post in
                        NavigationLink(value: post){
                            HomePageCardView(cardPost: post, image: vm.loadImage(imageName: post.imageName))
                        }
                    }
                    .navigationDestination(for: PostHomePageModel.self){post in
                        PostPageView(post: post)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .onAppear{
            vm.loadData()
        }
    }
}

#Preview {
    HomePageView()
}
