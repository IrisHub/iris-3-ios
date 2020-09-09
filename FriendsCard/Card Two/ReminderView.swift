//
//  ReminderView.swift
//  FriendsCard
//
//  Created by Shalin on 8/29/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import MessageUI
import Alamofire
import SwiftyJSON

struct ReminderView: View {
    @Binding var currentCardState: String?
    @ObservedObject var store: ContactStore
    @State var friendReminders: [DistantFriendProfile] = [DistantFriendProfile]()
    @State var friendLeaderboard: [LeaderboardProfile] = [LeaderboardProfile]()

    @State var leaderboardPresented: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.rBlack400.edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    HStack {
                        retinaIconButton(image: (Image(systemName: "chevron.left")), action: {
                            withAnimation {
                                self.currentCardState = nil
                            }
                        }).padding(24)
                        Spacer()
                    }.padding([.top], UIApplication.topInset)

                    Group {
                        HStack {
                            Text("For this week")
                                .retinaTypography(.h4_secondary)
                                .foregroundColor(.white)
                            .padding(.leading, 24)
                            Spacer()
                            retinaIconButton(image: (Image(systemName: "chart.bar")), foregroundColor: .rPink, backgroundColor: .clear, action: {
                                withAnimation {
                                    self.leaderboardPresented = true
                                }
                            }).padding([.leading, .trailing], 24)
                        }
                    }
                    
                    List {
                        ForEach(self.friendReminders, id: \.self) { (friend: DistantFriendProfile) in
                            ReminderCell(name: friend.name, phoneNumber: friend.id, emoji: friend.emoji)
                                .listRowInsets(EdgeInsets())
                        }
                    }
                    Spacer()
                }
                
                ActivityView(leaderboardPresented: self.$leaderboardPresented, friendLeaderboard: self.$friendLeaderboard).padding([.top, .bottom], UIApplication.bottomInset)
                .offset(x: 0, y: self.leaderboardPresented ? 0 : UIScreen.screenHeight + UIApplication.bottomInset)
            }
        }
        .onAppear() {
            if #available(iOS 14.0, *) {} else { UITableView.appearance().tableFooterView = UIView() }
            UITableView.appearance().separatorStyle = .none
            UITableViewCell.appearance().backgroundColor = Color.rBlack400.uiColor()
            UITableView.appearance().backgroundColor = Color.rBlack400.uiColor()

            self.getReminders()
        }
        .hideNavigationBar()
    }
    
    func getReminders() {
        let parameters = [
            "user_id": UserDefaults.standard.string(forKey: "phoneNumber"),
        ]
        let headers : HTTPHeaders = ["Content-Type": "application/json"]
        print(parameters)
        AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/contacts-get", method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
            print(response)
            do {
                let json = try JSON(data: response.data ?? Data())

                for (_,subJson):(String, JSON) in json["current_contacts"] {
                    let item = DistantFriendProfile(id: subJson["id"].stringValue, name: subJson["name"].stringValue, emoji: "".randomEmoji(), reachedOut: subJson["messaged"].boolValue)
                    self.friendReminders.append(item)
                }
                
                for (_,subJson):(String, JSON) in json["leaderboard"] {
                    let item = LeaderboardProfile(id: subJson["id"].stringValue, name: subJson["name"].stringValue, score: subJson["total"].stringValue, onIris: subJson["on_iris"].boolValue)
                    self.friendLeaderboard.append(item)
                }
            } catch {
                print("error")
            }
        }
    }

}
