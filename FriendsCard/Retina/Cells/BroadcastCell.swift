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
    var badgeTitles: [String]
    var buttonCommit: () -> Void = {}

    var body: some View {
        ZStack(alignment: .leading) {
            Color.rBlack400.edgesIgnoringSafeArea(.all)
            VStack {
                Divider().frame(height: 1).background(Color.rBlack200)
                Rectangle().frame(width: UIScreen.screenWidth, height: 72).foregroundColor(.clear)
                Divider().frame(height: 1).background(Color.rBlack200)
            }
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.rBlack100)
                        .frame(width: 48, height: 48)

                    Text(emoji)
                        .retinaTypography(.h4_main)
                }.padding(.leading, Space.rSpaceThree)
                
                VStack(alignment: .leading) {
                    Text(self.name.capitalizingFirstLetter()).foregroundColor(.rWhite).retinaTypography(.h5_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading)
                    HStack {
                        ForEach(self.badgeTitles, id: \.self) { (badgeTitle: String) in
                            Badge(text: badgeTitle, size: .h5).padding(.top, Space.rSpaceTwo)
                        }
                    }
                }.padding(.leading, Space.rSpaceTwo)
                
                Spacer()
            }
        }
    }
}

struct BroadcastCell_Previews: PreviewProvider {
    static var previews: some View {
        BroadcastCell(name: "Sam Gorman", emoji: "🤮", badgeTitles: [ "1", "3a", "5"])
    }
}
