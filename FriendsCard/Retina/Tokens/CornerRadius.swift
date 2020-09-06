//
//  CornerRadius.swift
//  Iris
//
//  Created by Shalin on 8/14/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

public struct CornerRadius {
    static let rCornerRadius: CGFloat = 2.0
}

extension View {
    // function for CornerRadius struct
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

/// Custom shape with independently rounded corners
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
