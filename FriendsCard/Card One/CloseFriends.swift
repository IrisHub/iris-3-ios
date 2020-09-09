//
//  CloseFriends.swift
//  FriendsCard
//
//  Created by Shalin on 8/29/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import MessageUI
import Alamofire
import SwiftyJSON

struct CloseFriends: View {
    @Binding var currentCardState: String?
    @ObservedObject var store: ContactStore
    @State var friendSchedules: [CloseFriendSchedule] = [CloseFriendSchedule]()
    @State var searchText : String?

    // The delegate required by `MFMessageComposeViewController`
    private let messageComposeDelegate = MessageComposerDelegate()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.rBlack400.edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    TopNavigationView(title: "Close Friends", description: "", backButton: true, backButtonCommit: { self.currentCardState = nil }, rightButton: false, searchBar: false, searchText: self.$searchText)

                    List {
                        ForEach(self.friendSchedules.filter { $0.onIris }, id: \.self) { (contact: CloseFriendSchedule) in
                            StatusCell(name: contact.name, status: contact.busy ? "busy" : "free", activity: contact.activity, description: contact.status)
                                .listRowInsets(EdgeInsets())
                        }

                        ForEach(self.friendSchedules.filter { !$0.onIris }, id: \.self) { (contact: CloseFriendSchedule) in
                            InviteCell(name: contact.name, buttonText: "Invite", buttonCommit: {self.presentMessageCompose(name: contact.name, phoneNumber: contact.id)})
                            .listRowInsets(EdgeInsets())
                        }
                    }
                    
                    Spacer()

                }
            }
        }
        .onAppear() {
            if #available(iOS 14.0, *) {} else { UITableView.appearance().tableFooterView = UIView() }
            UITableView.appearance().separatorStyle = .none
            UITableViewCell.appearance().backgroundColor = Color.rBlack400.uiColor()
            UITableView.appearance().backgroundColor = Color.rBlack400.uiColor()

            self.getSchedules()
        }
        .hideNavigationBar()
    }
    
    func getSchedules() {
        let parameters = [
            "user_id": UserDefaults.standard.string(forKey: "phoneNumber")
        ]
        let headers : HTTPHeaders = ["Content-Type": "application/json"]
        print(parameters)
        AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/friends-get", method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
            do {
                let json = try JSON(data: response.data ?? Data())
                print(json)
                for (i,subJson):(String, JSON) in json {
                    print(i)
                    print(subJson)
                    let item = CloseFriendSchedule(id: i, name: subJson["name"].stringValue, activity: subJson["event_title"].stringValue, status: subJson["status"].stringValue, onIris: subJson["on_iris"].boolValue, busy: subJson["busy"].boolValue)
                    self.friendSchedules.append(item)
                    print(self.friendSchedules.count)
                }
            } catch {
                print("error")
            }
        }
    }
}


extension CloseFriends {
    private class MessageComposerDelegate: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            // Customize here
            controller.dismiss(animated: true, completion: nil)
        }
    }
    private func presentMessageCompose(name: String, phoneNumber: String) {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = messageComposeDelegate
        composeVC.body = "Hey " + name + ", I want to add you as a close friend on Iris. Get the app so I can add you."
        composeVC.recipients = [phoneNumber]

        vc?.present(composeVC, animated: true, completion: nil)
    }
}
