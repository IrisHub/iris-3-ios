//
//  ProblemsView.swift
//  FriendsCard
//
//  Created by Shalin on 9/10/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct ProblemsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var className: String
    @State var assignmentName: String
    @State var problems: [Problems] = [Problems]()
    @State var searchText : String?

    @State var editViewPresented: Bool = false

    var body: some View {
        ZStack {
            Color.rBlack400.edgesIgnoringSafeArea(.all)
            VStack {
                TopNavigationView(title: assignmentName + ", " + className, description: "Share with other students in your class how long  problems take to finish.", backButton: true, backButtonCommit: { self.presentationMode.wrappedValue.dismiss() }, rightButton: true, rightButtonIcon: "pencil", rightButtonIconColor: Color.rPink, rightButtonCommit: { self.editViewPresented = false }, searchBar: false, searchText: self.$searchText)

                List {
                    ForEach(self.problems, id: \.self) { (problem: Problems) in
                        PollCell(name: problem.name, badgeTitle: problem.averageTime, badgeIcon: "clock")
                        .listRowInsets(EdgeInsets())
                    }
                }
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
