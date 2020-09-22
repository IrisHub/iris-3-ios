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
    
    @State private var isShowingAlert = false
    @State private var alertInput = ""
    
    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack {
                TopNavigationView(title: assignmentName + ", " + className, description: "", backButton: true, backButtonCommit: { self.presentationMode.wrappedValue.dismiss() }, rightButton: false, searchBar: false, searchText: self.$searchText)

                BroadcastCell(name: "Anonymous Le Conte", emoji: "🔭", badgeTitle: " I need help on...", isCurrentUser: true, editBroadcast: {
                    withAnimation {
                        self.isShowingAlert.toggle()
                    }
                })

                Divider().frame(height: 1).background(Color.rBlack200)
                
                List {
                    if (self.broadcasters.count != 0) {
                        Text("Needs help on").foregroundColor(.rWhite).retinaTypography(.p4_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading)
                        .padding([.leading, .bottom], 24)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .background(Color.rBlack500)
                    }
                    
                    ForEach(self.broadcasters, id: \.self) { (broadcaster: Broadcaster) in
                        BroadcastCell(name: broadcaster.name, emoji: broadcaster.icon, badgeTitle: broadcaster.tags, isCurrentUser: false)
                        .listRowInsets(EdgeInsets())
                        .padding(.bottom, Space.rSpaceFour)
                    }
                }
                Spacer()
            }
        }
        .textFieldAlert(isShowing: $isShowingAlert, text: $alertInput, title: "What do you need help on?")
        .hideNavigationBar()
    }
}
