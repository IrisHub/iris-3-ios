//
//  LecturesView.swift
//  FriendsCard
//
//  Created by Shalin on 9/15/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct LecturesView: View {
    @Binding var currentCardState: String?
    @State var classes: [Classes] = [Classes]()
    @State var lectures: [Lectures] = [Lectures]()
    @State var polls: [[Poll]] = [[Poll]]()
    @State var searchText : String?
    @State var selection: String? = nil

    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack {
                TopNavigationView(title: "FINESSE THE LECTURE", description: "", backButton: true, backButtonCommit: { self.currentCardState = nil }, rightButton: false, searchBar: false, searchText: self.$searchText)

                List {
                    ForEach(self.classes, id: \.self) { (currentClass: Classes) in
                        Group {
                            Text(currentClass.name).foregroundColor(.rWhite).retinaTypography(.p4_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading)
                            .padding([.leading], 24).padding(.top, 36)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .background(Color.rBlack500)
                            
                            ForEach(self.lectures.filter({ $0.classID == currentClass.id }), id: \.self) { (lecture: Lectures) in
                                
                                NavigationLink(destination: LecturePollsView(className: currentClass.name, lectureName: lecture.name, classID: lecture.classID, polls: self.$polls), tag: currentClass.name + lecture.name, selection: self.$selection) {
                                    ClassCells(name: lecture.name, badgeTitle: lecture.averageTime, badgeIcon: "clock")
                                }
                                .listRowInsets(.init(top: 0, leading: 0, bottom: -1, trailing: 0))
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .hideNavigationBar()
        .onAppear() {
            self.selection = nil
            self.fetchClasses()
        }
    }
    
    func fetchClasses() {
        self.classes = [Classes]()
        self.lectures = [Lectures]()
        self.polls = [[Poll]]()

        let parameters = [
            "user_id": UserDefaults.standard.string(forKey: "phoneNumber")
        ]
        let headers : HTTPHeaders = ["Content-Type": "application/json"]
        print(parameters)
        AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/lectures-classes-info", method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
            do {
                let json = try JSON(data: response.data ?? Data())
                print(json)
                for (i,pollsJson):(String, JSON) in json["polls"] {
                    var pollArray = [Poll]()
                    for (i,polls):(String, JSON) in pollsJson[i] {
                        let poll = Poll(id: i, name: polls["text"].stringValue, emoji: polls["icon"].stringValue)
                        pollArray.append(poll)
                    }
                    self.polls.append(pollArray)
                }

                
                for (_,subJson):(String, JSON) in json["classes"] {
                    let currentClass = Classes(id: subJson["class_id"].stringValue, name: subJson["class_name"].stringValue)
                    self.classes.append(currentClass)
                    
                    for (_,subJson2):(String, JSON) in subJson["lectures"] {
                        let lecture = Lectures(id: subJson2["lecture_id"].stringValue, classID: subJson["class_id"].stringValue, name: subJson2["assignment_id"].stringValue, averageTime: "3min", polls: subJson2["lecture_polls"].arrayValue.map { $0.map { $1.intValue } }, maxVotes: subJson2["lecture_max_votes"].arrayValue.map { $0.intValue}, votePercentages: subJson2["component_vote_pcts"].arrayValue.map { $0.intValue}, userVote: subJson2["user_votes"].arrayValue.map { $0.intValue })
                            
                        self.lectures.append(lecture)
                    }
                }
            } catch {
                print("error")
            }
        }
        
        self.classes.sort{ $0.id > $1.id }
        self.lectures.sort{ $0.id > $1.id }
    }

}
