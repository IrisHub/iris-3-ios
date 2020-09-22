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
    var badgeTitle: String
    var badgeIcon: String

    var body: some View {
        ZStack(alignment: .leading) {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack {
                Divider().frame(height: 1).background(Color.rBlack200)
                Rectangle().frame(width: UIScreen.screenWidth, height: 60).foregroundColor(.clear)
                Divider().frame(height: 1).background(Color.rBlack200)
            }
            HStack {
                Text(self.name.capitalizingFirstLetter()).foregroundColor(.white).retinaTypography(.h5_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading).padding(.leading, Space.rSpaceThree)
                Spacer()
//                Badge(text: badgeTitle, icon: badgeIcon, size: .h5).padding(.trailing, Space.rSpaceOne)
                Badge(text: badgeTitle, icon: badgeIcon, size: .h5).padding(.trailing, Space.rSpaceThree).isHidden(badgeTitle == "0")

            }
        }
    }
}

struct ClassCells_Previews: PreviewProvider {
    static var previews: some View {
        ClassCells(name: "Homework 1", badgeTitle: "10 hr", badgeIcon: "clock")
    }
}
