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
//    @Binding var currentCardState: String?
    @EnvironmentObject var screenCoordinator: ScreenCoordinator

    @State var classes: [Classes] = [Classes]()
    @State var lectures: [Lectures] = [Lectures]()
    @State var polls: [[Poll]] = [[Poll]]()
    @State var pollTitles: [String] = [String]()
    @State var searchText : String?
    @State var selection: String? = nil

    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack {
                TopNavigationView(title: "FINESSE THE LECTURE", description: "", backButton: true, backButtonCommit: { self.screenCoordinator.selectedPushItem = .home }, rightButton: false, searchBar: false, searchText: self.$searchText)

                List {
                    ForEach(self.classes, id: \.self) { (currentClass: Classes) in
                        Group {
                            Text(currentClass.name).foregroundColor(.rWhite).retinaTypography(.p4_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading)
                            .padding([.leading, .bottom, .trailing], 24).padding(.top, 36)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .background(Color.rBlack500)
                            
                            ForEach(self.lectures.filter({ $0.classID == currentClass.id }), id: \.self) { (lecture: Lectures) in
                                NavigationLink(destination: LecturePollsView(className: currentClass.name, lectureName: lecture.name, classID: lecture.classID, lecture: lecture, polls: self.$polls, pollTitles: self.$pollTitles), tag: currentClass.name + lecture.name, selection: self.$selection) {
                                    ClassCells(name: lecture.name, badgeTitles: lecture.maxVotes, badgeIcons: [""])
                                }
                                .listRowInsets(.init(top: 0, leading: 0, bottom: -1, trailing: 0))
                                .listRowBackground(Color.rBlack500)
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
        let staticJSON = UserDefaults.standard.bool(forKey: "useStaticJSON")

        self.classes = [Classes]()
        self.lectures = [Lectures]()
        self.polls = [[Poll]]()
        self.pollTitles = [String]()

        let parameters = [
            "user_id": UserDefaults.standard.string(forKey: "phoneNumber")
        ]
        let headers : HTTPHeaders = ["Content-Type": "application/json"]

        if staticJSON {
            AF.request("https://raw.githubusercontent.com/IrisHub/iris-3-endpoint-responses/master/lecture.json", method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                do {
                    let json = try JSON(data: response.data ?? Data())
                    self.pollTitles = json["poll_titles"].arrayValue.map { $0.stringValue }
                    for pollsJson : JSON in json["polls"].arrayValue {
                        var pollArray = [Poll]()
                        for (i,polls):(String, JSON) in pollsJson {
                            let poll = Poll(id: i, name: polls["text"].stringValue, emoji: polls["icon"].stringValue)
                            pollArray.append(poll)
                        }
                        self.polls.append(pollArray)
                    }
                    for (_,subJson):(String, JSON) in json["classes"] {
                        let currentClass = Classes(id: subJson["class_id"].stringValue, name: subJson["class_name"].stringValue)
                        self.classes.append(currentClass)
                        
                        for (_,subJson2):(String, JSON) in subJson["lectures"] {
                            let lecture = Lectures(id: subJson2["lecture_id"].stringValue, classID: subJson["class_id"].stringValue, name: subJson2["lecture_name"].stringValue, polls: subJson2["lecture_polls"].arrayValue.map { $0.map { $1.intValue } }, maxVotes: subJson2["lecture_max_votes"].arrayValue.map { $0.stringValue}, votePercentages: subJson2["lecture_vote_pcts"].arrayValue.map { $0.map { $1.intValue } }, userVote: subJson2["user_vote"].arrayValue.map { $0.intValue })
                                
                            self.lectures.append(lecture)
                        }
                    }
                } catch {
                    print("error")
                }
            }
        } else {
            AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/lectures-classes-info", method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                do {
                    let json = try JSON(data: response.data ?? Data())
                    self.pollTitles = json["poll_titles"].arrayValue.map { $0.stringValue }
                    for pollsJson : JSON in json["polls"].arrayValue {
                        var pollArray = [Poll]()
                        for (i,polls):(String, JSON) in pollsJson {
                            let poll = Poll(id: i, name: polls["text"].stringValue, emoji: polls["icon"].stringValue)
                            pollArray.append(poll)
                        }
                        self.polls.append(pollArray)
                    }
                    for (_,subJson):(String, JSON) in json["classes"] {
                        let currentClass = Classes(id: subJson["class_id"].stringValue, name: subJson["class_name"].stringValue)
                        self.classes.append(currentClass)
                        
                        for (_,subJson2):(String, JSON) in subJson["lectures"] {
                            let lecture = Lectures(id: subJson2["lecture_id"].stringValue, classID: subJson["class_id"].stringValue, name: subJson2["lecture_name"].stringValue, polls: subJson2["lecture_polls"].arrayValue.map { $0.map { $1.intValue } }, maxVotes: subJson2["lecture_max_votes"].arrayValue.map { $0.stringValue}, votePercentages: subJson2["lecture_vote_pcts"].arrayValue.map { $0.map { $1.intValue } }, userVote: subJson2["user_vote"].arrayValue.map { $0.intValue })
                                
                            self.lectures.append(lecture)
                        }
                    }
                } catch {
                    print("error")
                }
            }
        }
        
        self.classes.sort{ $0.id > $1.id }
        self.lectures.sort{ $0.id > $1.id }
    }

}
