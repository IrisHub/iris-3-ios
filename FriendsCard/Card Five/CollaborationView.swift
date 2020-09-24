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
//    @Binding var currentCardState: String?
    @EnvironmentObject var screenCoordinator: ScreenCoordinator

    @State var avatars: [Avatar] = [Avatar]()
    @State var classes: [Classes] = [Classes]()
    @State var assignments: [Assignments] = [Assignments]()
    @State var broadcasters: [Broadcaster] = [Broadcaster]()
    @State var searchText : String?
    @State var selection: String? = nil
    
    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack {
                TopNavigationView(title: "VIRTUAL STUDY GROUP", description: "", backButton: true, backButtonCommit: { self.screenCoordinator.selectedPushItem = .home }, rightButton: false, searchBar: false, searchText: self.$searchText)
                
                Spacer()
                List {
                    ForEach(self.classes, id: \.self) { (currentClass: Classes) in
                        Group {
                            Text(currentClass.name).foregroundColor(.rWhite).retinaTypography(.p4_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading)
                            .padding([.leading, .bottom, .trailing], 24).padding(.top, 36)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .background(Color.rBlack500)
                            
                            ForEach(Array(zip(self.assignments.filter({ $0.classID == currentClass.id }).indices, self.assignments.filter({ $0.classID == currentClass.id }))), id: \.0) { index, assignment in
                                NavigationLink(destination: SeePeopleView(className: currentClass.name, assignmentName: assignment.name, classID: currentClass.id, assignmentID: assignment.id, broadcasters: self.broadcasters.filter({ $0.classID == currentClass.id && $0.assignmentID == assignment.id }), assignments: self.assignments.filter({ $0.id == assignment.id }), name: self.avatars[index].name, avatar: self.avatars[index].icon, tags: self.avatars[index].tags), tag: assignment.name, selection: self.$selection) {
                                    ClassCells(name: assignment.name, badgeTitles: [assignment.averageTime], badgeIcons: ["clock"])
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
        self.assignments = [Assignments]()
        self.broadcasters = [Broadcaster]()
        self.avatars = [Avatar]()

        let parameters = [
            "user_id": UserDefaults.standard.string(forKey: "phoneNumber")
        ]
        let headers : HTTPHeaders = ["Content-Type": "application/json"]
        print(parameters)
        AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/collaboration-classes-info", method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
            do {
                let json = try JSON(data: response.data ?? Data())
                print(json)
                
                for (_,subJson):(String, JSON) in json["classes"] {
                    let currentClass = Classes(id: subJson["class_id"].stringValue, name: subJson["class_name"].stringValue)
                    self.classes.append(currentClass)
                    
                    for (_,subJson2):(String, JSON) in subJson["assignments"] {
                        let assignment = Assignments(id: subJson2["assignment_id"].stringValue, classID: subJson["class_id"].stringValue, name: subJson2["assignment_name"].stringValue)
                        self.assignments.append(assignment)
                        
                        let avatar = Avatar(name: subJson2["current_user_broadcast_name"].stringValue, icon: subJson2["current_user_broadcast_icon"].stringValue, tags: subJson2["current_user_broadcast_tags"].stringValue)
                        self.avatars.append(avatar)
                        
                        for (_,subJson3):(String, JSON) in subJson2["other_users"] {
                            let otherUsers = Broadcaster(id: subJson3["id"].stringValue, classID: subJson["class_id"].stringValue, assignmentID: subJson2["assignment_id"].stringValue, name: subJson3["broadcast_name"].stringValue, icon: subJson3["broadcast_icon"].stringValue, tags: subJson3["broadcast_tags"].stringValue)
                            if otherUsers.id != UserDefaults.standard.string(forKey: "phoneNumber") { self.broadcasters.append(otherUsers) }
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
