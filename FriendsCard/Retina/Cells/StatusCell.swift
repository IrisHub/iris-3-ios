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
    
    var body: some View {
        ZStack {
            Color.rBlack400.edgesIgnoringSafeArea(.all)
            VStack {
                ZStack(alignment: .leading) {
                    Rectangle().frame(width: UIScreen.screenWidth, height: 48).foregroundColor(.clear)
                    VStack {
                        HStack {
                            Circle()
                                .fill(self.status == "busy" ? Color.rRed : Color.green)
                                .frame(width: 12, height: 12)
                                .padding(.leading, 24)
                            
                            Text(name.capitalizingFirstLetter()).foregroundColor(.rWhite).retinaTypography(.h5_main).fixedSize(horizontal: false, vertical: true).frame(width: 104, alignment: .leading).padding(.leading, 12)
                        }
                    }
                }
                ZStack(alignment: .leading) {
                    Rectangle().frame(width: UIScreen.screenWidth-48, height: 112).foregroundColor(.rBlack100)
                    VStack {
                        
                        //contact.name.capitalizingFirstLetter()
                        Text(self.activity).foregroundColor(.rWhite).retinaTypography(.h4_main).fixedSize(horizontal: false, vertical: true).frame(width: UIScreen.screenWidth-96, alignment: .leading).padding([.leading, .bottom], 12)
                        Text(self.description).foregroundColor(.white).retinaTypography(.h6_main).fixedSize(horizontal: false, vertical: true).frame(width: UIScreen.screenWidth-96, alignment: .leading).padding(.leading, 12)
                    }
                }
            }
        }
    }
}

struct StatusCell_Previews: PreviewProvider {
    static var previews: some View {
        StatusCell(name: "Sam Gorman", status: "free", activity: "Interview Comm Training for New Members", description: "Busy in under 30min")
    }
}
