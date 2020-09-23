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
    @State var percents: [Int]
    @State var voted: Bool = false
    @State var classID: String
    @State var assignmentID: String? = nil
    @State var problemID: String? = nil
    @State var lectureID: String? = nil
    @State var pollID: String? = nil

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
                        ForEach(Array(zip(self.polls.indices, self.polls)), id: \.0) { index, poll in
                            retinaLeftButton(text: poll.name, left: .emoji, iconString: poll.emoji, size: .medium, progress: CGFloat(percents[index]), action: {
                                DispatchQueue.main.async {
                                    if (self.assignmentID != nil) {
                                        self.pressHomeworkPoll(classID: self.classID, assignmentID: self.assignmentID ?? "", problemID: self.problemID ?? "", value: Int(poll.id) ?? 0)
                                    } else {
                                        self.pressLecturePoll(classID: self.classID, lectureID: self.lectureID ?? "", pollID: self.pollID ?? "", value: Int(poll.id) ?? 0)
                                    }
                                }
                            }).padding([.bottom], -12)
                        }
                    }
                    
                    HStack {
                        if (voted) {
                            retinaButton(text: "Undo", style: .ghost, color: Color.rPink, action: {
                                if (self.assignmentID != nil) {
                                    self.pressHomeworkPoll(classID: self.classID, assignmentID: self.assignmentID ?? "", problemID: self.problemID ?? "", value: -1)
                                } else {
                                    self.pressLecturePoll(classID: self.classID, lectureID: self.lectureID ?? "", pollID: self.pollID ?? "", value: -1)
                                }
                            }).padding(.leading, Space.rSpaceTwo)
                            Spacer()
                        }
                    }
                }
        }
    }
    
    func pressHomeworkPoll(classID: String, assignmentID: String, problemID: String, value: Int) {
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
                                        let problem = Problems(id: subJson3["component_id"].stringValue, classID: subJson["class_id"].stringValue, assignmentID: subJson2["assignment_id"].stringValue, name: subJson3["component_name"].stringValue, averageTime: subJson3["component_avg_time"].stringValue, votes: subJson3["component_votes"].arrayValue.map { $0.intValue}, votePercentages: subJson3["component_vote_pcts"].arrayValue.map { $0.intValue}, userVote: subJson3["user_vote"].intValue)
                                        self.name = problem.name
                                        self.badgeTitle = problem.averageTime
                                        self.percents = problem.votePercentages
                                        self.voted = (problem.userVote != -1)
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
    
    func pressLecturePoll(classID: String, lectureID: String, pollID: String, value: Int) {
        let parameters : [String : Any] = [
            "user_id": UserDefaults.standard.string(forKey: "phoneNumber") as Any,
            "class_id": classID,
            "lecture_id": lectureID,
            "poll_id": pollID,
            "value": value
        ]
        print(parameters)
        let headers : HTTPHeaders = ["Content-Type": "application/json"]
        AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/lectures-classes-info", method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
            do {
                let json = try JSON(data: response.data ?? Data())
                for (_,subJson):(String, JSON) in json["classes"] {
                    for (_,subJson2):(String, JSON) in subJson["lectures"] {
                        let lecture = Lectures(id: subJson2["lecture_id"].stringValue, classID: subJson["class_id"].stringValue, name: subJson2["assignment_id"].stringValue, polls: subJson2["lecture_polls"].arrayValue.map { $0.map { $1.intValue } }, maxVotes: subJson2["lecture_max_votes"].arrayValue.map { $0.intValue}, votePercentages: subJson2["lecture_vote_pcts"].arrayValue.map { $0.intValue}, userVote: subJson2["user_vote"].arrayValue.map { $0.intValue })
                        
                        
//                        self.name = problem.name
//                        self.badgeTitle = problem.averageTime
//                        self.percents = problem.votePercentages
//                        self.voted = (problem.userVote != -1)

                        
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
