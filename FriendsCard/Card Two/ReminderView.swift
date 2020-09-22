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
//    @Binding var currentCardState: String?
    @EnvironmentObject var screenCoordinator: ScreenCoordinator

    @State var friendReminders: [DistantFriendProfile] = [DistantFriendProfile]()
    @State var friendLeaderboard: [LeaderboardProfile] = [LeaderboardProfile]()

    @State var searchText : String?

    // The delegate required by `MFMessageComposeViewController`
    private let messageComposeDelegate = MessageComposerDelegate()

    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack() {
                TopNavigationView(title: "STAY IN TOUCH", description: "", backButton: true, backButtonCommit: { self.screenCoordinator.selectedPushItem = .home }, rightButton: false, searchBar: false, searchText: self.$searchText)

                List {
                    if (self.friendReminders.count != 0) {
                        Text("Remind me").foregroundColor(.rWhite).retinaTypography(.p4_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading)
                        .padding([.leading, .bottom, .trailing], 24)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }

                    ForEach(self.friendReminders, id: \.self) { (friend: DistantFriendProfile) in
                        ReminderCell(name: friend.name, frequency: "", messaged: friend.messaged, buttonCommit: {self.presentMessageCompose(name: friend.name, phoneNumber: friend.id)})
                        .listRowInsets(.init(top: 0, leading: 0, bottom: -1, trailing: 0))
                    }
                }
                .padding(.top, Space.rSpaceTwo)
                Spacer()
            }
        }
        .hideNavigationBar()
        .onAppear() {
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
