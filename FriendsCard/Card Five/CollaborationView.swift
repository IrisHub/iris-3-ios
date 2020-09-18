//
//  CollaborationView.swift
//  FriendsCard
//
//  Created by Shalin on 9/17/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct CollaborationView: View {
    @Binding var currentCardState: String?
    @State var avatar: Avatar = Avatar()
    @State var classes: [Classes] = [Classes]()
    @State var assignments: [Assignments] = [Assignments]()
    @State var broadcasters: [Broadcaster] = [Broadcaster]()
    @State var searchText : String?
    @State var selection: String? = nil

    var body: some View {
        ZStack {
            Color.rBlack400.edgesIgnoringSafeArea(.all)
            VStack {
                TopNavigationView(title: "Collaboration", description: "", backButton: true, backButtonCommit: { self.currentCardState = nil }, rightButton: false, searchBar: false, searchText: self.$searchText)

                List {
                    ForEach(self.classes, id: \.self) { (currentClass: Classes) in
                        Group {
                            Text(currentClass.name).foregroundColor(.rWhite).retinaTypography(.h4_main).fixedSize(horizontal: false, vertical: true).padding(.bottom, 12)
                            
                            ForEach(self.assignments.filter({ $0.classID == currentClass.id }), id: \.self) { (assignment: Assignments) in
                                
                                NavigationLink(destination: SeePeopleView(className: currentClass.name, assignmentName: assignment.name, classID: currentClass.id, assignmentID: assignment.id, broadcasters: self.broadcasters.filter({ $0.classID == currentClass.id && $0.assignmentID == assignment.id }), assignments: self.assignments.filter({ $0.id == assignment.id }), name: self.avatar.name, avatar: self.avatar.icon, tags: assignment.userBroadcastTags), tag: assignment.name, selection: self.$selection) {
                                    ClassCells(name: assignment.name, badgeTitle: assignment.averageTime, badgeIcon: "clock")
                                }
                                .isDetailLink(false)
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
            if #available(iOS 14.0, *) {} else { UITableView.appearance().tableFooterView = UIView() }
            UITableView.appearance().separatorStyle = .none
            UITableViewCell.appearance().backgroundColor = Color.rBlack400.uiColor()
            UITableView.appearance().backgroundColor = Color.rBlack400.uiColor()
        }
    }
    
    func fetchClasses() {
        self.classes = [Classes]()
        self.assignments = [Assignments]()
        self.broadcasters = [Broadcaster]()

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
                self.avatar = Avatar(name: json["current_user_broadcast_name"].stringValue, icon: json["current_user_broadcast_icon"].stringValue)

                
                for (_,subJson):(String, JSON) in json["classes"] {
                    let currentClass = Classes(id: subJson["class_id"].stringValue, name: subJson["class_name"].stringValue)
                    self.classes.append(currentClass)
                    
                    for (_,subJson2):(String, JSON) in subJson["assignments"] {
                        let assignment = Assignments(id: subJson2["assignment_id"].stringValue, classID: subJson["class_id"].stringValue, name: subJson2["assignment_name"].stringValue, userBroadcasted: subJson2["current_user_broadcasted"].boolValue, userBroadcastTags: subJson2["current_user_broadcast_tags"].arrayValue.map { $0.stringValue})
                        self.assignments.append(assignment)
                        
                        for (_,subJson3):(String, JSON) in subJson2["other_users"] {
                            let otherUsers = Broadcaster(id: subJson3["id"].stringValue, classID: subJson["class_id"].stringValue, assignmentID: subJson2["assignment_id"].stringValue, name: subJson3["broadcast_name"].stringValue, icon: subJson3["broadcast_icon"].stringValue, tags: subJson3["broadcast_tags"].arrayValue.map { $0.stringValue})
                            self.broadcasters.append(otherUsers)
                        }
                    }
                }
            } catch {
                print("error")
            }
        }
        
        self.classes.sort{ $0.id > $1.id }
        self.broadcasters.sort{ $0.id > $1.id }
        self.assignments.sort{ $0.id > $1.id }
    }
}
