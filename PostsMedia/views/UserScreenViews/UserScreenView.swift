//
//  UserScreenView.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 02/01/26.
//

import SwiftUI

struct UserScreenView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = UserScreenViewModel()
    
    @State var showTaskList: Bool = false
    
    let userId: Int
    let postQuantity = 10
    
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                Color("primaryBackground")
                Color(.secondarySystemBackground)
            }
            .ignoresSafeArea(edges: .all)
            
            ScrollView{
                VStack(spacing: 24){
                    profileInformations
                    
                    HStack(spacing: -24){
                        boxInformations(title: "ID", value: "\(userId)")
                        boxInformations(title: "Posts", value: "\(postQuantity)")
                    }
                    
                    getUrlString(link: vm.user.website)
                    
                    userLastTasks
                    
                }
                .background(Color("primaryBackground"))
                
                
            }
            .navigationTitle(Text("Profile"))
            .navigationBarTitleDisplayMode(.inline)
            .scrollBounceBehavior(.basedOnSize)
        }
        .task{
            await vm.fetchUser(userId: userId)
        }
    }
}

private extension UserScreenView {
    
    var profileInformations: some View {
        VStack{
            ZStack(alignment: .bottomTrailing){
                CircularProfileImageView(height: 100, width: 100, image: vm.loadImage(imageName: "avatar-\(userId)"))
                    .overlay(
                        Circle()
                            .stroke(style: StrokeStyle(lineWidth: 2))
                            .fill(Color("primaryBackground"))
                            .shadow(color: Color("primaryBackgroundContrast"), radius: 3, x: 0.5, y: 0.5)
                    )
                
                Circle()
                    .fill(.green)
                    .frame(width: 24, height: 24)
                    .frame(alignment: .bottomTrailing)
            }
            .frame(maxWidth: .infinity)
            
            Text(vm.user.name)
                .font(.headline)
            
            Text("@\(vm.user.username)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    var userLastTasks: some View{
        VStack(alignment: .leading, spacing: 16){
            
            HStack{
                Image(systemName: "checkmark.rectangle.fill")
                    .foregroundStyle(.green)
                Text("Tarefas recentes")
            }
            .padding(.bottom, 16)
            .font(Font.title2)
            
            if vm.isLoading {
                LoadingStateView(elements: 5, completeLoad: false)
            } else{
                
                todoTaskList
                
                Button {
                    showTaskList.toggle()
                } label: {
                    Text("Ver todas as tarefas")
                }
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .sheet(isPresented: $showTaskList){
                    taskListSheet
                }
            }
            
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .task{
            await vm.fetchTodoTasks(userId: userId)
        }
    }
    
    var todoTaskList: some View{
        StandardListView(itens: vm.taskList.suffix(5)){ todoTask in
            VStack(alignment: .leading, spacing: 8){
                HStack(spacing: 12){
                    Image(systemName: todoTask.completed ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(todoTask.completed ? .green : .gray)
                        .font(.title3)
                    
                    Text(todoTask.title)
                        .strikethrough(todoTask.completed, color: .gray)
                        .foregroundStyle(todoTask.completed ? .gray : .primary)
                    
                    Spacer()
                }
                .padding(.vertical, 8)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .lineLimit(2)
        }
    }
    
    var taskListSheet: some View{
        NavigationStack{
            List(vm.taskList){ todoTask in
                HStack(spacing: 12){
                    Image(systemName: todoTask.completed ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(todoTask.completed ? .green : .gray)
                        .font(.title3)
                    
                    Text(todoTask.title)
                        .strikethrough(todoTask.completed, color: .gray)
                        .foregroundColor(todoTask.completed ? .gray : .primary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Tarefas de \(vm.user.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button {
                        showTaskList.toggle()
                    } label: {
                        
                        Image(systemName: "xmark")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
            }
        }
    }
    
    func boxInformations(title: String, value: String) -> some View{
        return ZStack{
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
                .frame(height: 88)
                .frame(maxWidth: .infinity)
            VStack{
                Text(title)
                    .font(.title)
                    .fontWeight(.semibold)
                Text(value)
                    .font(.title2)
                    .fontWeight(.regular)
            }
        }
        .padding(.horizontal, 28)
    }
    
    @ViewBuilder
    func getUrlString(link: String) -> some View{
        if let url = URL(string: link) {
            Link(destination: url){
                HStack{
                    Image(systemName: "globe")
                    Text(vm.user.website)
                }
            }
        } else{
            EmptyView()
        }
    }
}

#Preview {
    NavigationStack {
        UserScreenView(userId: 6)
    }
}
