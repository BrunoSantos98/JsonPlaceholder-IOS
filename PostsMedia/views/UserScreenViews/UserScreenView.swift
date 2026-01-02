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
                    
                    HStack(spacing: 16){
                        boxInformations(title: "ID", value: "\(vm.user.id)")
                        boxInformations(title: "Posts", value: "\(postQuantity)")
                    }
                    
                    Link(destination: getUrlString(link: vm.user.website)){
                        HStack{
                            Image(systemName: "globe")
                            Text(vm.user.website)
                        }
                    }
                    
                    userLastTasks
                }
                .background(.white)
                
                
            }
            .navigationTitle(Text("Profile"))
            .navigationBarTitleDisplayMode(.inline)
            .scrollBounceBehavior(.basedOnSize)
        }
        .onAppear{
            vm.fetchUser(userId: userId)
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
                            .stroke(style: StrokeStyle(lineWidth: 4))
                            .fill(.white)
                            .shadow(radius: 5)
                    )
                
                Circle()
                    .fill(.green)
                    .frame(width: 28, height: 28)
                    .frame(alignment: .bottomTrailing)
                    .overlay(
                        Circle()
                            .stroke(style: StrokeStyle(lineWidth: 2))
                            .fill(.white)
                            .shadow(radius: 5, x: 2, y: 2)
                    )
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
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .onAppear{
            vm.fetchTodoTasks(userId: userId)
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
            //MARK: Mudar esse width e testar depois
                .frame(width:126, height: 88)
            VStack{
                Text(title)
                    .font(.title)
                    .fontWeight(.semibold)
                Text(value)
                    .font(.title2)
                    .fontWeight(.regular)
            }
        }
    }
    
    //mudar essa logica para safe unwrapping
    func getUrlString(link: String) -> URL{
        guard let url = URL(string: link) else {
            return URL(string: "www.google.com")!
        }
        
        return url
    }
}

#Preview {
    NavigationStack {
        UserScreenView(userId: 6)
    }
}
