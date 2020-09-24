//
//  Badge.swift
//  FriendsCard
//
//  Created by Shalin on 9/9/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct Badge: View {
    enum TextStyle { case h4, h5 }
    var text: String
    var icon: String?
    var size: TextStyle

    var body: some View {
        ZStack {
            HStack {
                if icon != nil && icon != "" {
                    Image(systemName: icon ?? "" )
                    .retinaTypography(.h5_secondary)
                    .foregroundColor(.rPink)
                }

                Text(text)
                    .retinaTypography(.h5_main)
                    .foregroundColor(.rPink)
            }
            .padding([.leading, .trailing], Space.rSpaceTwo).padding([.top, .bottom], self.size == .h4 ? Space.rSpaceTwo: Space.rSpaceOne/2)
            .background(Color.pink.opacity(0.2))
            .cornerRadius(CornerRadius.rCornerRadius)
        }
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge(text: "New!", size: .h5)
    }
}
