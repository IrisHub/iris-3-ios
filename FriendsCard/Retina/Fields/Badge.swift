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
    var size: TextStyle

    var body: some View {
        ZStack {
            Text(text)
                .retinaTypography(.h5_main)
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
