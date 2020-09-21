//
//  SeePeopleView.swift
//  FriendsCard
//
//  Created by Shalin on 9/17/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct SeePeopleView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var className: String
    @State var assignmentName: String
    
    @State var classID: String
    @State var assignmentID: String
    
    @State var broadcasters: [Broadcaster] = [Broadcaster]()
    @State var assignments: [Assignments] = [Assignments]()
    @State var name: String
    @State var avatar: String
    @State var tags: String
    
    @State var searchText : String?
    
    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack {
                TopNavigationView(title: assignmentName + ", " + className, description: "", backButton: true, backButtonCommit: { self.presentationMode.wrappedValue.dismiss() }, rightButton: false, searchBar: false, searchText: self.$searchText)

                Divider().frame(height: 1).background(Color.rBlack200)
                Text("Needs help on").foregroundColor(.rGrey100).retinaTypography(.h5_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading)

                List {
                    ForEach(self.broadcasters, id: \.self) { (broadcaster: Broadcaster) in
                        BroadcastCell(name: broadcaster.name, emoji: broadcaster.icon, badgeTitle: broadcaster.tags)
                        .listRowInsets(EdgeInsets())
                        .padding(.bottom, Space.rSpaceFour)
                    }
                }
                Spacer()
            }
        }
        .hideNavigationBar()
    }
}
