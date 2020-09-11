//
//  PollCell.swift
//  FriendsCard
//
//  Created by Shalin on 9/9/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct PollCell: View {
    var name: String
    var badgeTitle: String
    var badgeIcon: String
    var voted: Bool = false

    var body: some View {
        ZStack(alignment: .leading) {
            Color.rBlack400.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text(self.name.capitalizingFirstLetter()).foregroundColor(.white).retinaTypography(.h5_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading).padding(.leading, Space.rSpaceThree)
                    Spacer()
                    Badge(text: badgeTitle, icon: badgeIcon, size: .h5).padding(.trailing, Space.rSpaceThree)

                }
                retinaLeftButton(text: "30min", left: .emoji, iconString: "🙃", size: .medium, action: {
                    DispatchQueue.main.async {
                    }
                })
                retinaLeftButton(text: "1hr", left: .emoji, iconString: "😬", size: .medium, action: {
                    DispatchQueue.main.async {
                    }
                })
                retinaLeftButton(text: "2hrs", left: .emoji, iconString: "🤢", size: .medium, action: {
                    DispatchQueue.main.async {
                    }
                })
                retinaLeftButton(text: "3hrs", left: .emoji, iconString: "🤢", size: .medium, action: {
                    DispatchQueue.main.async {
                    }
                })
                HStack {
                    if (voted) {
                        retinaButton(text: "Undo", style: .ghost, color: Color.rPink, action: { print("click") }).padding(.leading, Space.rSpaceTwo)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct PollCell_Previews: PreviewProvider {
    static var previews: some View {
        PollCell(name: "Problem 1", badgeTitle: "1hr, 10 min", badgeIcon: "clock")
    }
}
