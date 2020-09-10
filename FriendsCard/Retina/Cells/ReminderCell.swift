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
        ZStack {
            Color.rBlack400.edgesIgnoringSafeArea(.all)
            HStack {
                Spacer()
                VStack(alignment: .leading) {
                    Text(emoji)
                        .retinaTypography(.h3_main)
                        .padding(.bottom, 12)
                    Text(name.capitalizingFirstLetter())
                        .foregroundColor(.rWhite)
                        .retinaTypography(.h5_main)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 12)
                    Text(phoneNumber)
                        .foregroundColor(.rGrey100)
                        .retinaTypography(.h6_main)
                        .padding(.bottom, 12)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    retinaButton(text: "Text " + name.split(separator: " ").first!, style: .outlineOnly, color: .rPink, action: {
                        DispatchQueue.main.async {
                            self.buttonCommit()
                        }
                    }).frame(width: UIScreen.screenWidth-96, height: 36, alignment: .trailing)
                }.padding([.top, .bottom], 24)
                Spacer()
            }
            .background(Color.rBlack100)
            .padding([.leading, .trailing], 24)
        }
    }
}

struct ReminderCell_Previews: PreviewProvider {
    static var previews: some View {
        ReminderCell(name: "Kanyes Thaker", phoneNumber: "818-203-3202", emoji: "🤪")
    }
}
