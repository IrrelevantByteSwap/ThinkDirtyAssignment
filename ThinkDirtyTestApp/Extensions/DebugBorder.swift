//
//  DebugBorder.swift
//  ThinkDirtyTestApp
//
//  Created by Vivienne Fosh on 25.09.2022.
//

import SwiftUI

struct DebugBorder: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content.overlay(Rectangle().stroke(color))
    }
}

extension View {
    func debugBorder(color: Color = .blue) -> some View {
        return self.modifier(DebugBorder(color: color))
    }
}
