//
//  TopNavigationHeader.swift
//  FriendsCard
//
//  Created by Shalin on 9/20/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct TopNavigationHeader: View {
    var heading: String
    var title : String
    var description: String
    var backButton: Bool = false
    var backButtonCommit : () -> Void = {}

    var body: some View {
        VStack(alignment: .leading) {
            if (self.backButton) {
                HStack {
                    retinaIconButton(image: (Image(systemName: "chevron.left")), backgroundColor: .clear, action: {
                        withAnimation {
                            self.backButtonCommit()
                        }
                    })
                    Spacer()
                }.padding([.leading, .bottom], 6)
            }
            
            Text(heading).retinaTypography(.h5_main).foregroundColor(.rPink).padding([.leading, .trailing], 24).padding(.bottom, 12)

            Text(title).retinaTypography(.p2_main).foregroundColor(.rWhite).padding([.leading, .trailing], 24).padding(.bottom, 12)
                .fixedSize(horizontal: false, vertical: true)

            Text(description).retinaTypography(.h4_secondary).foregroundColor(.rGrey100).padding([.leading, .trailing], 24)
                .fixedSize(horizontal: false, vertical: true)
        }.padding(.bottom, 24)
    }
}

struct TopNavigationHeader_Previews: PreviewProvider {
    static var previews: some View {
        TopNavigationHeader(heading: "CARD01 SEPTEMBER19-2020", title: "WHEN2MEET MY CLOSE FRIENDS", description: "Know when your friends are free without having to ask.", backButton: true)
    }
}
