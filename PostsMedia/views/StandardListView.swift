//
//  StandardListView.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 02/01/26.
//

import SwiftUI

struct StandardListView<T: Identifiable, Content: View>: View where T.ID: Equatable {
    
    let itens: [T]
    @ViewBuilder let content: (T) -> Content
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(itens) { item in
                
                content(item)
                    .padding(.vertical, 8)
                
                if item.id != itens.last?.id {
                    Divider()
                        .padding(.leading, 4)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color("primaryBackground"))
        .cornerRadius(12)
        .shadow(color: Color("primaryBackgroundContrast").opacity(0.3), radius: 5, x: 0, y: 0)
    }
}

//MARK: Preview Area
private struct MockItem: Identifiable {
    let id = UUID()
    let text: String
}

#Preview {
    
    let mockData = [
        MockItem(text: "Item Teste 1"),
        MockItem(text: "Item Teste 2"),
        MockItem(text: "Item Teste 3")
    ]
    
    ZStack {
        Color(.secondarySystemBackground).ignoresSafeArea()
        
        StandardListView(itens: mockData) { item in
            HStack {
                Image(systemName: "star.fill").foregroundStyle(.yellow)
                Text(item.text)
            }
        }
        .padding()
    }
}
