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
    @State var searchText : String?

    var body: some View {
        ZStack {
            Color.rBlack400.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                TopNavigationView(title: "Friend Activity", description: "You’re doing a great job so far, keep it up!", backButton: false, rightButton: true, rightButtonIcon: "xmark", rightButtonIconColor: Color.rWhite, rightButtonCommit: { self.leaderboardPresented = false }, searchBar: false, searchText: self.$searchText)

                List {
                    ForEach(self.friendLeaderboard, id: \.self) { (friend: LeaderboardProfile) in
                        LeaderCell(title: friend.name, subtitle: friend.score)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: -1, trailing: 0))
                    }
                }
                .padding(.top, Space.rSpaceTwo)
                
                Spacer()
            }
        }
        .hideNavigationBar()
        .onAppear() {
            if #available(iOS 14.0, *) {} else { UITableView.appearance().tableFooterView = UIView() }
            UITableView.appearance().separatorStyle = .none
            UITableViewCell.appearance().backgroundColor = Color.rBlack400.uiColor()
            UITableView.appearance().backgroundColor = Color.rBlack400.uiColor()
        }
    }
}
