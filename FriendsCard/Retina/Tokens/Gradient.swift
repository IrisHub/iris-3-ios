//
//  Gradient.swift
//  Iris
//
//  Created by Shalin on 7/23/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

// MARK: - API
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    public func foreground<Overlay: View>(_ overlay: Overlay) -> some View {
        _Foreground(overlay: overlay, for: self)
    }
}

// MARK: - Implementation
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private struct _Foreground<Content: View, Overlay: View>: View {
    let content: Content
    let overlay: Overlay
    
    internal init(overlay: Overlay, for content: Content) {
        self.content = content
        self.overlay = overlay
    }
    
    var body: some View {
        content.overlay(overlay).mask(content)
    }
}

extension LinearGradient {
    static let retinaSunsetVertical = LinearGradient(gradient: Gradient(colors: [.rPink, .rPurple]), startPoint: .topLeading, endPoint: .bottomTrailing)
}
