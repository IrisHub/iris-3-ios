//
//  PollCell.swift
//  FriendsCard
//
//  Created by Shalin on 9/9/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct PollCell: View {
    @State var name: String
    @State var badgeTitle: String
    @State var badgeIcon: String
    @State var polls: [Poll]
    @State var voted: Bool = false
    @State var classID: String
    @State var assignmentID: String? = nil
    @State var problemID: String

    var body: some View {
        ZStack(alignment: .leading) {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Text(self.name.capitalizingFirstLetter()).foregroundColor(.white).retinaTypography(.h5_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading).padding(.leading, Space.rSpaceThree)
                        Spacer()
                        Badge(text: badgeTitle, icon: badgeIcon, size: .h5).padding(.trailing, Space.rSpaceThree)
                            .isHidden(badgeTitle == "0")
                    }
                    VStack {
                        ForEach(self.polls, id: \.self) { (poll: Poll) in
                            retinaLeftButton(text: poll.name, left: .emoji, iconString: poll.emoji, size: .medium, action: {
                                DispatchQueue.main.async {
                                    if (self.assignmentID != nil) {
                                        self.pressPoll(classID: self.classID, assignmentID: self.assignmentID ?? "", problemID: self.problemID, value: Int(poll.id) ?? 0)
                                    } else {
                                        
                                    }
                                }
                            }).padding([.bottom], -12)
                        }
                    }
                    
                    HStack {
                        if (voted) {
                            retinaButton(text: "Undo", style: .ghost, color: Color.rPink, action: {
                                self.pressPoll(classID: self.classID, assignmentID: self.assignmentID ?? "", problemID: self.problemID, value: -1)
                            }).padding(.leading, Space.rSpaceTwo)
                            Spacer()
                        }
                    }
                }
        }
    }
    
    func pressPoll(classID: String, assignmentID: String, problemID: String, value: Int) {
        let parameters : [String : Any] = [
            "user_id": UserDefaults.standard.string(forKey: "phoneNumber") as Any,
            "class_id": classID,
            "assignment_id": assignmentID,
            "problem_id": problemID,
            "value": value
        ]
        print(parameters)
        let headers : HTTPHeaders = ["Content-Type": "application/json"]
        AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/homework-classes-info", method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
            do {
                let json = try JSON(data: response.data ?? Data())
                print(json)
                
                for (_,subJson):(String, JSON) in json["classes"] {
                    if (subJson["class_id"].stringValue == classID) {
                        for (_,subJson2):(String, JSON) in subJson["assignments"] {
                            if (subJson2["assignment_id"].stringValue == assignmentID) {
                                for (_,subJson3):(String, JSON) in subJson2["assignment_components"] {
                                    if (subJson3["component_id"].stringValue == problemID) {
                                        let problem = Problems(id: subJson3["component_id"].stringValue, classID: subJson["class_id"].stringValue, assignmentID: subJson2["assignment_id"].stringValue, name: subJson3["component_name"].stringValue, averageTime: subJson3["component_avg_time"].stringValue, votes: subJson3["component_votes"].arrayValue.map { $0.intValue}, votePercentages: subJson3["component_vote_pcts"].arrayValue.map { $0.intValue}, userVote: subJson3["user_votes"].intValue)
                                        self.name = problem.name
                                        self.badgeTitle = problem.averageTime
                                        print(problem)
                                    }
                                }
                            }
                        }
                    }
                }
            } catch {
                print("error")
            }
        }
    }

}

//struct PollCell_Previews: PreviewProvider {
//    static var previews: some View {
//        PollCell(name: "Problem 1", badgeTitle: "1hr, 10 min", badgeIcon: "clock", polls: <#[Poll]#>)
//    }
//}
