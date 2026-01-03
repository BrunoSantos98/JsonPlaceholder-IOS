//
//  LoadingStateView.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 03/01/26.
//

import SwiftUI

struct LoadingStateView: View {
    
    let elements: Int
    var completeLoad: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<elements, id: \.self) { _ in
                SkeletonRowView(completeLoad: completeLoad)
                Divider().padding(.leading, 16)
            }
        }

    }
}

// MARK: - Skeleton component
private struct SkeletonRowView: View {
    @State private var isAnimating = false
    let completeLoad: Bool

    var body: some View {
        if completeLoad{
            loadCompleteStruct
        } else {
            loadHalfStruct
        }
    }
}

private extension SkeletonRowView{
    var loadCompleteStruct: some View{
        HStack(spacing: 12) {
            Circle()
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 8) {
                
                RoundedRectangle(cornerRadius: 4)
                    .containerRelativeFrame(.horizontal, count: 3, span: 1, spacing: 0)
                    .frame(height: 14)
                
                RoundedRectangle(cornerRadius: 4)
                    .frame(height: 14)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .foregroundStyle(Color("primaryBackgroundContrast").opacity(0.3))
        .opacity(isAnimating ? 0.3 : 1.0)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
    
    var loadHalfStruct: some View{
        RoundedRectangle(cornerRadius: 4)
            .frame(height: 28)
            .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .foregroundStyle(Color("primaryBackgroundContrast").opacity(0.3))
        .opacity(isAnimating ? 0.3 : 1.0)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    LoadingStateView(elements: 8)
}
