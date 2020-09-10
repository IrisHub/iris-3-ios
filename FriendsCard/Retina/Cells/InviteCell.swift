//
//  InviteCell.swift
//  FriendsCard
//
//  Created by Shalin on 8/29/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct InviteCell: View {
    var name: String
    var buttonText: String
    var buttonCommit: () -> Void = {}

    var body: some View {
        ZStack(alignment: .leading) {
            Color.rBlack400.edgesIgnoringSafeArea(.all)
            VStack {
                Divider().frame(height: 1).background(Color.rBlack200)
                Rectangle().frame(width: UIScreen.screenWidth, height: 60).foregroundColor(.clear)
                Divider().frame(height: 1).background(Color.rBlack200)
            }
            HStack {
                Circle()
                    .fill(Color.rBlack100)
                    .frame(width: 12, height: 12)
                    .padding(.leading, 24)
                
                Text(self.name.capitalizingFirstLetter()).foregroundColor(.white).retinaTypography(.h5_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading).padding(.leading, 12)
                
                Spacer()
                retinaButton(text: buttonText, style: .outlineOnly, color: .rPink, action: {
                    self.buttonCommit()
                }).frame(width: (UIScreen.screenWidth-48)/3, height: 36, alignment: .trailing).padding([.leading, .trailing], 12)
            }
        }
    }
}

struct InviteCell_Previews: PreviewProvider {
    static var previews: some View {
        InviteCell(name: "Sam Gorman", buttonText: "Invite")
    }
}
