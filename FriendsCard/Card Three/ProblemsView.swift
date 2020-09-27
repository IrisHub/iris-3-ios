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
    
    @State var classID: String
    @State var assignmentID: String
    
    @State var problems: [Problems] = [Problems]()
    @Binding var polls: [Poll]
    @State var searchText : String?

    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack {
                TopNavigationView(title: assignmentName + ", " + className, description: "", backButton: true, backButtonCommit: { self.presentationMode.wrappedValue.dismiss() }, rightButton: false, rightButtonIcon: "pencil", rightButtonIconColor: Color.rPink, rightButtonCommit: {  }, searchBar: false, searchText: self.$searchText)

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(self.problems, id: \.self) { (problem: Problems) in
                            PollCell(name: problem.name, badgeTitle: problem.averageTime, badgeIcon: "clock", polls: self.polls, percents: problem.votePercentages, voted: (problem.userVote != -1), classID: self.classID, assignmentID: self.assignmentID, problemID: problem.id)
                            .padding(.top, 36)
                        }
                    }
                }
                Spacer()
            }
        }
        .hideNavigationBar()
        .onAppear() {
            print(self.polls)
        }
    }
}
