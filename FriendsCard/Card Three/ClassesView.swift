//
//  ClassesView.swift
//  FriendsCard
//
//  Created by Shalin on 9/10/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct ClassesView: View {
    @Binding var currentCardState: String?
    @State var classes: [Classes] = [Classes]()
    @State var assignments: [Assignments] = [Assignments]()
    @State var problems: [Problems] = [Problems]()
    @State var polls: [Poll] = [Poll]()
    @State var searchText : String?

    var body: some View {
        ZStack {
            Color.rBlack400.edgesIgnoringSafeArea(.all)
            VStack {
                TopNavigationView(title: "Share Homework Length", description: "", backButton: true, backButtonCommit: { self.currentCardState = nil }, rightButton: false, searchBar: false, searchText: self.$searchText)

                List {
                    ForEach(self.classes, id: \.self) { (currentClass: Classes) in
                        Group {
                            Text(currentClass.name).foregroundColor(.rWhite).retinaTypography(.h4_main).fixedSize(horizontal: false, vertical: true).padding(.bottom, 12)
                            
                            ForEach(self.assignments.filter({ $0.classID == currentClass.id }), id: \.self) { (assignment: Assignments) in
                                
                                NavigationLink(destination: ProblemsView(className: currentClass.name, assignmentName: assignment.name, classID: currentClass.id, assignmentID: assignment.id, problems: self.problems.filter({ $0.classID == currentClass.id && $0.assignmentID == assignment.id }), polls: self.$polls)) {
                                    ClassCells(name: assignment.name, badgeTitle: assignment.averageTime, badgeIcon: "clock")
                                    .listRowInsets(.init(top: 0, leading: 0, bottom: -1, trailing: 0))
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .hideNavigationBar()
        .onAppear() {
            self.fetchClasses()
            if #available(iOS 14.0, *) {} else { UITableView.appearance().tableFooterView = UIView() }
            UITableView.appearance().separatorStyle = .none
            UITableViewCell.appearance().backgroundColor = Color.rBlack400.uiColor()
            UITableView.appearance().backgroundColor = Color.rBlack400.uiColor()
        }
    }
    
    func fetchClasses() {
        self.classes = [Classes]()
        self.assignments = [Assignments]()
        self.problems = [Problems]()
        self.polls = [Poll]()

        let parameters = [
            "user_id": UserDefaults.standard.string(forKey: "phoneNumber")
        ]
        let headers : HTTPHeaders = ["Content-Type": "application/json"]
        print(parameters)
        AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/homework-classes-info", method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
            do {
                let json = try JSON(data: response.data ?? Data())
                print(json)
                for (i,pollsJson):(String, JSON) in json["polls"][0] {
                    let poll = Poll(id: i, name: pollsJson["text"].stringValue, emoji: pollsJson["icon"].stringValue)
                    print(poll)
                    self.polls.append(poll)
                }

                
                for (_,subJson):(String, JSON) in json["classes"] {
                    let currentClass = Classes(id: subJson["class_id"].stringValue, name: subJson["class_name"].stringValue)
                    self.classes.append(currentClass)
                    
                    for (_,subJson2):(String, JSON) in subJson["assignments"] {
                        let assignment = Assignments(id: subJson2["assignment_id"].stringValue, classID: subJson["class_id"].stringValue, name: subJson2["assignment_name"].stringValue, averageTime: subJson2["assignment_avg_time"].stringValue)
                        self.assignments.append(assignment)
                        
                        for (_,subJson3):(String, JSON) in subJson2["assignment_components"] {
                            let problem = Problems(id: subJson3["component_id"].stringValue, classID: subJson["class_id"].stringValue, assignmentID: subJson2["assignment_id"].stringValue, name: subJson3["component_name"].stringValue, averageTime: subJson3["component_avg_time"].stringValue, votes: subJson3["component_votes"].arrayValue.map { $0.intValue})
                            self.problems.append(problem)
                        }
                    }
                }
            } catch {
                print("error")
            }
        }
        
        self.classes.sort{ $0.id > $1.id }
        self.problems.sort{ $0.id > $1.id }
        self.assignments.sort{ $0.id > $1.id }
    }

}