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
    var frequency: String
    var messaged: Bool
    var buttonCommit: () -> Void = {}

    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack {
                Divider().frame(height: 1).background(Color.rBlack200)
                Rectangle().frame(width: UIScreen.screenWidth, height: 60).foregroundColor(.clear)
                Divider().frame(height: 1).background(Color.rBlack200)
            }

            HStack {
                VStack(alignment: .leading) {
                    Text(name.capitalizingFirstLetter())
                        .foregroundColor(.rWhite)
                        .retinaTypography(.h5_main)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 6)

                    Button(action: {
                    }) {
                        HStack {
                            Image(systemName: "pencil").foregroundColor(.rGrey100)
                            Text(frequency)
                                .foregroundColor(.rGrey100)
                                .retinaTypography(.h6_main)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                
                Spacer()
                retinaButton(text: messaged ? "TEXTED" : "TEXT!", style: messaged ?  .ghost: .outlineOnly, color: messaged ? .rPink : .rPink, action: {
                    DispatchQueue.main.async {
                        self.buttonCommit()
                    }
                }).frame(width: UIScreen.screenWidth/4, height: 36, alignment: .trailing)
            }.padding([.leading], 24).padding([.trailing], 12)
        }
    }
}

struct ReminderCell_Previews: PreviewProvider {
    static var previews: some View {
        ReminderCell(name: "Kanyes Thaker", frequency: "Daily", messaged: true)
    }
}
