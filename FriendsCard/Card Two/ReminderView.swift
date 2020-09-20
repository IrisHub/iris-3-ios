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
    @State var friendReminders: [DistantFriendProfile] = [DistantFriendProfile]()
    @State var friendLeaderboard: [LeaderboardProfile] = [LeaderboardProfile]()

    @State var searchText : String?

    // The delegate required by `MFMessageComposeViewController`
    private let messageComposeDelegate = MessageComposerDelegate()

    var body: some View {
        ZStack {
            Color.rBlack400.edgesIgnoringSafeArea(.all)
            VStack() {
                TopNavigationView(title: "For this week", description: "", backButton: true, backButtonCommit: { self.currentCardState = nil }, rightButton: true, rightButtonIcon: "chart.bar", rightButtonCommit: { self.leaderboardPresented = true }, searchBar: false, searchText: self.$searchText)

                List {
                    ForEach(self.friendReminders, id: \.self) { (friend: DistantFriendProfile) in
                        ReminderCell(name: friend.name, phoneNumber: friend.id, emoji: friend.emoji, messaged: friend.messaged, buttonCommit: {self.presentMessageCompose(name: friend.name, phoneNumber: friend.id)})
                            .listRowInsets(EdgeInsets())
                            .padding(.bottom, Space.rSpaceThree)
                    }
                }
                .padding(.top, Space.rSpaceTwo)
                Spacer()
            }
            
            ActivityView(leaderboardPresented: self.$leaderboardPresented, friendLeaderboard: self.$friendLeaderboard).padding([.top, .bottom], UIApplication.bottomInset)
                .offset(x: 0, y: self.leaderboardPresented ? 0 : UIScreen.screenHeight + UIApplication.bottomInset)
        }
        .hideNavigationBar()
        .onAppear() {
            if #available(iOS 14.0, *) {} else { UITableView.appearance().tableFooterView = UIView() }
            UITableView.appearance().separatorStyle = .none
            UITableViewCell.appearance().backgroundColor = Color.rBlack400.uiColor()
            UITableView.appearance().backgroundColor = Color.rBlack400.uiColor()

            self.getReminders()
        }
    }
        
    func getReminders() {
        friendReminders = [DistantFriendProfile]()
        friendLeaderboard = [LeaderboardProfile]()

        let parameters = [
            "user_id": UserDefaults.standard.string(forKey: "phoneNumber")
        ]
        let headers : HTTPHeaders = ["Content-Type": "application/json"]
        print(parameters)
        AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/contacts-get", method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
            do {
                let json = try JSON(data: response.data ?? Data())
                print(json)
                for (_,subJson):(String, JSON) in json["current_contacts"] {
                    let item = DistantFriendProfile(id: subJson["id"].stringValue, name: subJson["name"].stringValue, emoji: "".randomEmoji(), messaged: subJson["messaged"].boolValue)
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
    
    func reachedOut(phoneNumber: String) {
        friendLeaderboard = [LeaderboardProfile]()

        let parameters = [
            "user_id": UserDefaults.standard.string(forKey: "phoneNumber"),
            "messaged": phoneNumber
        ]
        let headers : HTTPHeaders = ["Content-Type": "application/json"]
        print(parameters)
        AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/contacts-get", method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
            do {
                let json = try JSON(data: response.data ?? Data())
                self.friendLeaderboard = [LeaderboardProfile]()
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


extension ReminderView {
    private class MessageComposerDelegate: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            switch result.rawValue {
                case 0 :
                    print("Sending Message cancelled")
                    controller.dismiss(animated: true, completion: nil)
                case 1:
                    print("Message sent")
                    controller.dismiss(animated: true, completion: nil)
                case 2:
                    print("Sending message failed")
                    controller.dismiss(animated: true, completion: nil)
                default:
                    break
            }
        }
    }
    private func presentMessageCompose(name: String, phoneNumber: String) {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = messageComposeDelegate
        composeVC.body = "Hey "
        composeVC.recipients = [phoneNumber]
        self.reachedOut(phoneNumber: phoneNumber)

        vc?.present(composeVC, animated: true, completion: nil)
    }
}
