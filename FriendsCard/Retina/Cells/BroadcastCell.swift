//
//  BroadcasterCell.swift
//  FriendsCard
//
//  Created by Shalin on 9/17/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct BroadcastCell: View {
    var name: String
    var emoji: String
    var badgeTitle: String
    var buttonCommit: () -> Void = {}

    var body: some View {
        ZStack(alignment: .leading) {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack {
                Divider().frame(height: 1).background(Color.rBlack200)
                Rectangle().frame(width: UIScreen.screenWidth, height: 72).foregroundColor(.clear)
                Divider().frame(height: 1).background(Color.rBlack200)
            }
            HStack {
                ZStack {
                    Color.rBlack100.edgesIgnoringSafeArea(.all)

                    Text(emoji)
                        .retinaTypography(.h4_main)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Circle()
                                .fill(Color.green)
                                .frame(width: 12, height: 12)
                        }
                    }
                }
                .frame(width: 60, height: 60)
                .padding(.leading, Space.rSpaceThree)
                
                
                VStack(alignment: .leading) {
                    Text(self.name.capitalizingFirstLetter()).foregroundColor(.rWhite).retinaTypography(.h5_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading)
                    Badge(text: self.badgeTitle, size: .h5)
                }.padding(.leading, Space.rSpaceTwo)
                
                Spacer()
            }
        }
    }
}

struct BroadcastCell_Previews: PreviewProvider {
    static var previews: some View {
        BroadcastCell(name: "Sam Gorman", emoji: "🤮", badgeTitle: "1, 3a, 5")
    }
}
