//
//  ClassCells.swift
//  FriendsCard
//
//  Created by Shalin on 9/9/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct ClassCells: View {
    var name: String
    var badgeTitles: [String]
    var badgeIcons: [String] = [""]

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                Divider().frame(height: 1).background(Color.rBlack200)
                Rectangle().frame(width: UIScreen.screenWidth, height: 60).foregroundColor(.clear)
                Divider().frame(height: 1).background(Color.rBlack200)
            }
            HStack {
                Text(self.name.capitalizingFirstLetter()).foregroundColor(.white).retinaTypography(.h5_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading).padding(.leading, Space.rSpaceThree)
                Spacer()
                
                HStack {
                    ForEach(Array(zip(self.badgeTitles.indices, self.badgeTitles)), id: \.0) { index, badgeTitle in
                        Badge(text: badgeTitle, icon: badgeIcons.count != badgeTitles.count ? "" : badgeIcons[index], size: .h5).padding(.trailing, (index == self.badgeTitles.count - 1 ) ? Space.rSpaceThree : Space.rSpaceOne).isHidden(badgeTitle == "0")
                    }
                }
            }
        }
    }
}

struct ClassCells_Previews: PreviewProvider {
    static var previews: some View {
        ClassCells(name: "Homework 1", badgeTitles: ["10 hr"], badgeIcons: ["clock"])
    }
}
