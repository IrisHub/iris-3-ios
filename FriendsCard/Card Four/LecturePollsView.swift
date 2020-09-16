//
//  LecturePollsView.swift
//  FriendsCard
//
//  Created by Shalin on 9/16/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct LecturePollsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var className: String
    @State var lectureName: String
    
    @State var classID: String
    
    @State var lectures: [Lectures] = [Lectures]()
    @Binding var polls: [[Poll]]
    @State var searchText : String?

    @State var editViewPresented: Bool = false

    var body: some View {
        ZStack {
            Color.rBlack400.edgesIgnoringSafeArea(.all)
            VStack {
                TopNavigationView(title: lectureName + ", " + className, description: "Share with other students in your class how hard the lecture was to understand.", backButton: true, backButtonCommit: { self.presentationMode.wrappedValue.dismiss() }, rightButton: false, searchBar: false, searchText: self.$searchText)

                List {
                    ForEach(self.lectures, id: \.self) { (lecture: Lectures) in
                        ForEach(self.polls, id: \.self) { (poll: [Poll]) in
                            PollCell(name: "How was the lecture?", badgeTitle: lecture.averageTime, badgeIcon: "clock", polls: poll, classID: self.classID, problemID: lecture.id)
                            .listRowInsets(EdgeInsets())
                        }
                    }
                }
                Spacer()
            }
        }
        .hideNavigationBar()
        .onAppear() {
            print(self.polls)
            if #available(iOS 14.0, *) {} else { UITableView.appearance().tableFooterView = UIView() }
            UITableView.appearance().separatorStyle = .none
            UITableViewCell.appearance().backgroundColor = Color.rBlack400.uiColor()
            UITableView.appearance().backgroundColor = Color.rBlack400.uiColor()
        }
    }

}
