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
    var isCurrentUser: Bool
    var editBroadcast: () -> Void = {}

    var body: some View {
        ZStack(alignment: .leading) {
//            Color.rBlack500.edgesIgnoringSafeArea(.all)
            if (!isCurrentUser) {
                VStack {
                    Divider().frame(height: 1).background(Color.rBlack200)
                    Rectangle().frame(width: UIScreen.screenWidth, height: 72).foregroundColor(.clear)
                    Divider().frame(height: 1).background(Color.rBlack200)
                }
            }
            
            HStack {
                ZStack {
                    Color.rBlack100.edgesIgnoringSafeArea(.all)

                    Text(emoji)
                        .retinaTypography(isCurrentUser ? .h3_main : .h4_main)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Circle()
                                .fill(Color.rGreen)
                                .frame(width: isCurrentUser ? 24 : 18, height: isCurrentUser ? 24 : 18)
                                .offset(x: isCurrentUser ? 6 : 3,y: isCurrentUser ? 6 : 3)
                                .overlay(Circle().stroke(Color.rBlack300, lineWidth: 2).offset(x: isCurrentUser ? 6 : 3,y: isCurrentUser ? 6 : 3))
                        }
                    }
                }
                .frame(width: isCurrentUser ? 72 : 60, height: isCurrentUser ? 72 : 60)
                .padding(.leading, Space.rSpaceThree)
                
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(self.name.capitalizingFirstLetter()).foregroundColor(.rWhite).retinaTypography(.h5_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading)
                        if (isCurrentUser) {
                            Text("(ME)").foregroundColor(.rPink).retinaTypography(.h5_main)
                        }
                    }
                    Button(action: {
                        DispatchQueue.main.async {
                            self.editBroadcast()
                        }
                    }) {
                        Badge(text: self.badgeTitle, icon: isCurrentUser ? "pencil" : "", size: .h5)
                    }
                }.padding(.leading, Space.rSpaceTwo)
                
                Spacer()
            }
        }
        .padding(.bottom, -1)
    }
}

struct BroadcastCell_Previews: PreviewProvider {
    static var previews: some View {
        BroadcastCell(name: "Sam Gorman", emoji: "🤮", badgeTitle: "1, 3a, 5", isCurrentUser: true)
    }
}
