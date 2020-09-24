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
    
    @State var lecture: Lectures
    @Binding var polls: [[Poll]]
    @Binding var pollTitles: [String]
    @State var searchText : String?

    @State var editViewPresented: Bool = false

    var body: some View {
        
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack {
                TopNavigationView(title: lectureName + ", " + className, description: "", backButton: true, backButtonCommit: { self.presentationMode.wrappedValue.dismiss() }, rightButton: false, searchBar: false, searchText: self.$searchText)

                List {
                    Group {
                        ForEach(Array(zip(self.polls.indices, self.polls)), id: \.0) { index, poll in
                            PollCell(name: pollTitles[index], badgeTitle: lecture.maxVotes[index], badgeIcon: "", polls: poll, percents: lecture.votePercentages[index], voted: (lecture.userVote[index] != -1), classID: self.classID, problemID: lecture.id)
                                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .background(Color.rBlack500)
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
