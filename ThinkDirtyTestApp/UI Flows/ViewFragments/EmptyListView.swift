//
//  EmptyListView.swift
//  ThinkDirtyTestApp
//
//  Created by Vivienne Fosh on 25.09.2022.
//

import SwiftUI

struct SkeletonList: View {
    
    @State private var animate = false
    
    let startGradient = Gradient(colors: [.clear, .gray.opacity(0.4)])
    
    var body: some View {
        VStack(spacing: 24) {
            cell
            cell
            cell
            
            Spacer()
        }
        .padding(16)
        .animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: animate)
        .onAppear {
            animate.toggle()
        }
    }
    
    @ViewBuilder
    var cell: some View {
        let gradient = LinearGradient(gradient: startGradient, startPoint: animate ? .topTrailing : .topLeading, endPoint: .topLeading).blur(radius: 0.4)
        HStack {
            gradient
                .frame(width: 100, height: 100)
            VStack(alignment: .leading, spacing: 12) {
                gradient
                    .frame(height: 25)
                gradient
                    .frame(width: 200, height: 25)
                gradient
                    .frame(width: 150, height: 25)
            }
        }
    }
}
