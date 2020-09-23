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
    
    @State var selectedFrequencyIndex: Int = 0
    @State var selectedID: String = ""
    @State var isShowingPicker = false
    @State var commitChanges = false
    var frequencyOptions = ["Daily", "Every few days", "Weekly", "Every 2 weeks"]



    // The delegate required by `MFMessageComposeViewController`
    private let messageComposeDelegate = MessageComposerDelegate()

    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack() {
                TopNavigationView(title: "STAY IN TOUCH", description: "", backButton: true, backButtonCommit: { self.screenCoordinator.selectedPushItem = .home }, rightButton: false, searchBar: false, searchText: self.$searchText)
                
                List {
                    HStack {
                        Text("Oski’s Health: ").foregroundColor(.rWhite).fixedSize(horizontal: false, vertical: true).retinaTypography(.p5_main)
                        Text("Unwell 😨").foregroundColor(.rRed).fixedSize(horizontal: false, vertical: true).retinaTypography(.p5_main)
                    }
                    .padding([.leading, .bottom, .trailing], 24)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))


                    Image("sadoski")
                    .resizable()
                    .frame(width: UIScreen.screenSize.width-48, height: (UIScreen.screenSize.width-48.0)/800.0 * 600.0)
                    .aspectRatio(contentMode: .fit)
                    .padding([.leading, .bottom, .trailing], 24)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .background(Color.rBlack500)
                    
                    if (self.friendReminders.count != 0) {
                        Text("Remind me").foregroundColor(.rWhite).retinaTypography(.p4_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading)
                        .padding([.leading, .bottom, .trailing], 24)
                        .background(Color.rBlack500)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }

                    ForEach(self.friendReminders, id: \.self) { (friend: DistantFriendProfile) in
                        ReminderCell(name: friend.name, frequency: "Daily", messaged: friend.messaged, editCommit: { selectedID = friend.id; withAnimation { self.isShowingPicker.toggle() } }, buttonCommit: {self.presentMessageCompose(name: friend.name, phoneNumber: friend.id)})
                        .listRowInsets(.init(top: 0, leading: 0, bottom: -1, trailing: 0))
                    }
                }
                .padding(.top, Space.rSpaceTwo)
                Spacer()
            }
        }
        .pickerView(isShowing: self.$isShowingPicker, commitChanges: self.$commitChanges, picked: self.$selectedFrequencyIndex, title: "Change Frequency", options: frequencyOptions)
        .onChange(of: commitChanges) { _ in
            self.changeFrequency(phoneNumber: self.selectedID, frequency: self.frequencyOptions[self.selectedFrequencyIndex])
        }
        .hideNavigationBar()
        .onAppear() {
            self.getReminders()
        }
    }
    
    func changeFrequency(phoneNumber: String, frequency: String) {
        print(phoneNumber, frequency)
        
        // Reset everything
        self.selectedID = ""
        self.selectedFrequencyIndex = 0
        self.commitChanges = false
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
