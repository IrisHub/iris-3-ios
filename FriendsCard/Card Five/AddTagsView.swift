//
//  AddTagsView.swift
//  FriendsCard
//
//  Created by Shalin on 9/17/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct AddTagsView: View {
    @Binding var addTagsPresented: Bool
    
    @Binding var name: String
    @Binding var avatar: String
    @Binding var tags: [String]

    @State var searchText : String?

    var body: some View {
        ZStack {
            Color.rBlack400.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                TopNavigationView(title: "", description: "", backButton: false, rightButton: true, rightButtonIcon: "xmark", rightButtonIconColor: Color.rWhite, rightButtonCommit: { self.addTagsPresented = false }, searchBar: false, searchText: self.$searchText)

//                List {
//                    ForEach(self.friendLeaderboard, id: \.self) { (friend: LeaderboardProfile) in
//                        LeaderCell(title: friend.name, subtitle: friend.score)
//                        .listRowInsets(.init(top: 0, leading: 0, bottom: -1, trailing: 0))
//                    }
//                }
//                .padding(.top, Space.rSpaceTwo)
                
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
