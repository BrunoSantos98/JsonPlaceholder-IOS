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
            ScrollView{
                LazyVStack{
                    ForEach(vm.postsHomePage){post in
                        NavigationLink(value: post){
                            HomeScreenCardView(cardPost: post, image: vm.loadImage(imageName: post.imageName))
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .navigationDestination(for: PostHomePageModel.self){post in
                    PostScreenView(post: post)
                }
            }
        .onAppear{
            vm.loadData()
        }
    }
}

#Preview {
    NavigationStack{
        HomeScreenView()
    }
}
