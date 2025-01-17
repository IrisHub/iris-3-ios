//
//  StatusCell.swift
//  FriendsCard
//
//  Created by Shalin on 8/29/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct StatusCell: View {
    var name: String
    var status: String
    var activity: String
    var description: String
    var buttonCommit: () -> Void = {}

    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack {
                Divider().frame(height: 1).background(Color.rBlack200)
                Rectangle().frame(width: UIScreen.screenWidth, height: 204).foregroundColor(.clear)
                Divider().frame(height: 1).background(Color.rBlack200)
            }

            Button(action: {
                DispatchQueue.main.async {
                    self.buttonCommit()
                }
            }) {
                VStack {
                    HStack {
                        Rectangle()
                            .fill(self.status == "busy" ? Color.rRed : Color.rGreen)
                            .frame(width: 18, height: 18)
                            .padding(.leading, 24)
                        
                        Text(name.capitalizingFirstLetter()).foregroundColor(.rWhite).retinaTypography(.h5_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading).padding(.leading, 12)
                        
                        Spacer()
                    }.padding(.bottom, 12)

                    HStack {
                        VStack(alignment: .leading) {
                            Text(self.activity).foregroundColor(.rWhite).retinaTypography(.h4_main).fixedSize(horizontal: false, vertical: true).padding(.bottom, 6)
                            Text(self.description).foregroundColor(.white).retinaTypography(.h6_main).fixedSize(horizontal: false, vertical: true)
                        }.padding([.top, .bottom], 24).padding(.leading, 12)
                        Spacer()
                    }
                    .background(Color.rBlack100)
                    .cornerRadius(CornerRadius.rCornerRadius)
                    .padding([.leading, .trailing], 12)
                }
            }
        }
        .padding(.bottom, -1)
    }
}

struct StatusCell_Previews: PreviewProvider {
    static var previews: some View {
        StatusCell(name: "Sam Gorman", status: "free", activity: "[MDB] Interview Comm Training for New Members", description: "Busy in under 30min")
    }
}
