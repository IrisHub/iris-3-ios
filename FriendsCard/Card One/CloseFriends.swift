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
//    @Binding var currentCardState: String?
    @EnvironmentObject var screenCoordinator: ScreenCoordinator

    @State var friendSchedules: [CloseFriendSchedule] = [CloseFriendSchedule]()
    @State var searchText : String?

    // The delegate required by `MFMessageComposeViewController`
    private let messageComposeDelegate = MessageComposerDelegate()
    
    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                TopNavigationView(title: "MY CLOSE FRIENDS", description: "", backButton: true, backButtonCommit: { self.screenCoordinator.selectedPushItem = .home }, rightButton: false, searchBar: false, searchText: self.$searchText)

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if (self.friendSchedules.filter { $0.onIris }.count != 0) {
                            Text("Calendars").foregroundColor(.rWhite).retinaTypography(.p4_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading)
                            .padding([.leading, .bottom, .trailing], 24).padding(.top, 32)
                        }

                        ForEach(self.friendSchedules.filter { $0.onIris }, id: \.self) { (contact: CloseFriendSchedule) in
                            StatusCell(name: contact.name, status: contact.busy ? "busy" : "free", activity: contact.activity, description: contact.status, buttonCommit: {self.presentMessageCompose(name: contact.name, phoneNumber: contact.id)})
                        }
                        
                        if (self.friendSchedules.filter { !$0.onIris }.count != 0) {
                            Text("Invite to Iris").foregroundColor(.rWhite).retinaTypography(.p4_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading)
                            .padding([.leading, .bottom], 24).padding(.top, 32)
                        }

                        ForEach(self.friendSchedules.filter { !$0.onIris }, id: \.self) { (contact: CloseFriendSchedule) in
                            InviteCell(name: contact.name, buttonText: "Invite", messaged: false, buttonCommit: {self.presentMessageCompose(name: contact.name, phoneNumber: contact.id, invite: true)})
                        }
                    }
                }
                
                Spacer()

            }
        }
        .hideNavigationBar()
        .onAppear() {
            self.getSchedules()
        }
    }
    
    func getSchedules() {
        let staticJSON = UserDefaults.standard.bool(forKey: "useStaticJSON")

        self.friendSchedules = [CloseFriendSchedule]()
        let parameters = [
            "user_id": UserDefaults.standard.string(forKey: "phoneNumber")
        ]
        if staticJSON {
            AF.request("https://raw.githubusercontent.com/IrisHub/iris-3-endpoint-responses/master/schedules.json", method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
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
        } else {
            let headers : HTTPHeaders = ["Content-Type": "application/json"]
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
}


extension CloseFriends {
    class MessageComposerDelegate: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            switch (result) {
            case .cancelled:
                print("Message was cancelled")
            case .failed:
                print("Message failed")
            case .sent:
                print("Message was sent")
            default:
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                controller.hideKeyboard()
                controller.dismiss(animated: true, completion: nil)
            }
        }
    }
    private func presentMessageCompose(name: String, phoneNumber: String, invite: Bool = false) {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = messageComposeDelegate
        composeVC.body = invite ? name + " can we share our schedules + know when we're free or busy easier with this app called Iris I've been trying out https://itunes.apple.com/app/apple-store/id1530662507?mt=8" : "hey "
        composeVC.recipients = [phoneNumber]

        DispatchQueue.main.async {
            vc?.present(composeVC, animated: true, completion: nil)
        }
    }
}
