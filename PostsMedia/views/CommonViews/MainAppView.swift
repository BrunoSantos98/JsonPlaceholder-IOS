//
//  MainAppView.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 02/01/26.
//

import SwiftUI

struct MainAppView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab){
            NavigationStack{
                HomeScreenView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)
            
            NavigationStack{
                SavedPostsView()
            }
            .tabItem {
                Label("Saved", systemImage: "bookmark.fill")
            }
            .tag(1)
            
            NavigationStack{
                UserScreenView(userId: 7 )
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
            .tag(2)
        }
    }
}

#Preview {
    MainAppView()
}
