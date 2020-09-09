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
                if icon != nil {
                    Image(systemName: icon ?? "" )
                    .retinaTypography(.p5_main)
                    .foregroundColor(.rPink)
                }

                Text(text)
                    .retinaTypography(.h5_main)
                    .foregroundColor(.rPink)
            }
            .padding([.leading, .trailing], Space.rSpaceTwo).padding([.top, .bottom], self.size == .h4 ? Space.rSpaceTwo: Space.rSpaceOne)
            .background(Color.pink.opacity(0.2))
        }
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge(text: "New!", size: .h5)
    }
}
