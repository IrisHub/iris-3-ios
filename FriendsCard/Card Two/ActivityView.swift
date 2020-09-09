//
//  ActivityView.swift
//  FriendsCard
//
//  Created by Shalin on 8/29/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct ActivityView: View {
    @Binding var leaderboardPresented: Bool
    @Binding var friendLeaderboard: [LeaderboardProfile]

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    Text("Friend Activity")
                        .retinaTypography(.h4_secondary)
                        .foregroundColor(.white)
                    .padding(.leading, 24)
                    Spacer()
                    
                    retinaIconButton(image: (Image(systemName: "xmark")), action: {
                        withAnimation {
                            self.leaderboardPresented = false
                        }
                    }).padding([.leading, .trailing], 24)
                }
            }.padding([.top], UIApplication.topInset*2)
            
            Text("You’re doing a great job so far, keep it up!").retinaTypography(.h5_main, color: .rWhite).padding([.leading, .top], 24)
            
            List {
                ForEach(self.friendLeaderboard, id: \.self) { (friend: LeaderboardProfile) in
                    LeaderCell(title: friend.name, subtitle: friend.score)
                    .listRowInsets(EdgeInsets())
                }
            }
            
            Spacer()
        }
        .background(Color.rBlack400)
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            if #available(iOS 14.0, *) {} else { UITableView.appearance().tableFooterView = UIView() }
            UITableView.appearance().separatorStyle = .none
            UITableViewCell.appearance().backgroundColor = Color.rBlack400.uiColor()
            UITableView.appearance().backgroundColor = Color.rBlack400.uiColor()
        }
    }
}
