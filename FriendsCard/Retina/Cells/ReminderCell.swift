//
//  ReminderCell.swift
//  FriendsCard
//
//  Created by Shalin on 8/30/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct ReminderCell: View {
    var name: String
    var phoneNumber: String
    var emoji: String
    var buttonCommit: () -> Void = {}

    var body: some View {
        ZStack(alignment: .leading) {
            // json -> cellJson
            Rectangle().frame(width: UIScreen.screenWidth-48, height: 224).foregroundColor(.rBlack100)
            VStack(alignment: .leading) {
                Text(emoji).padding(.bottom, 12).retinaTypography(.h3_main).padding(.leading, 24)
                Text(name.capitalizingFirstLetter()).foregroundColor(.rWhite).retinaTypography(.h5_main).fixedSize(horizontal: false, vertical: true).padding(.leading, 24).padding(.bottom, 12)
                Text(phoneNumber).foregroundColor(.rGrey100).retinaTypography(.h6_main).fixedSize(horizontal: false, vertical: true).padding(.leading, 24)
                
                retinaButton(text: "Text " + name.split(separator: " ").first!, style: .outlineOnly, color: .rPink, action: {
                    DispatchQueue.main.async {
                        self.buttonCommit()
                    }
                }).frame(width: UIScreen.screenWidth-96, height: 36, alignment: .trailing).padding([.top, .bottom], 12).padding([.leading], 24)
            }
        }
    }
}

struct ReminderCell_Previews: PreviewProvider {
    static var previews: some View {
        ReminderCell(name: "Kanyes Thaker", phoneNumber: "818-203-3202", emoji: "🤪")
    }
}
