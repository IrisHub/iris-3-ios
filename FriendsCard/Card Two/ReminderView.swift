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
import URLImage

struct ReminderView: View {
//    @Binding var currentCardState: String?
    @EnvironmentObject var screenCoordinator: ScreenCoordinator

    @State var friendReminders: [ReminderProfile] = [ReminderProfile]()
    @State var oskiProfile: OskiProfile = OskiProfile(health: "", image: "", score: 0)

    @State var searchText : String?
    
    @State var selectedFrequencyIndex: Int = 0
    @State var selectedID: String = ""
    @State var isShowingPicker = false
    @State var commitChanges = false
    @State var frequencyOptions: [String] = [String]()



    // The delegate required by `MFMessageComposeViewController`
    private let messageComposeDelegate = MessageComposerDelegate()

    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack() {
                TopNavigationView(title: "STAY IN TOUCH", description: "", backButton: true, backButtonCommit: { self.screenCoordinator.selectedPushItem = .home }, rightButton: false, searchBar: false, searchText: self.$searchText)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Oski’s Health: ").foregroundColor(.rWhite).fixedSize(horizontal: false, vertical: true).retinaTypography(.p5_main)
                            Text(oskiProfile.health).foregroundColor(oskiProfile.score == 0 ? .rGreen : .rRed).fixedSize(horizontal: false, vertical: true).retinaTypography(.p5_main)
                        }
                        .padding([.leading, .bottom, .trailing], 24)

                        if (oskiProfile.image != "") {
                            URLImage((URL(string: oskiProfile.image) ?? URL(string: "https://www.minasjr.com.br/wp-content/themes/minasjr/images/placeholders/placeholder_large_dark.jpg")!)){ proxy in
                                proxy.image
                                .resizable()
                                .renderingMode(.original)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.screenSize.width-48, height: (UIScreen.screenSize.width-48.0)/800.0 * 600.0)
                            }
                            .padding([.leading, .bottom, .trailing], 24)
                        }
                        
                        if (self.friendReminders.count != 0) {
                            Text("Remind me").foregroundColor(.rWhite).retinaTypography(.p4_main).fixedSize(horizontal: false, vertical: true).frame(alignment: .leading)
                            .padding([.leading, .bottom, .trailing], 24)
                        }

                        ForEach(self.friendReminders, id: \.self) { (friend: ReminderProfile) in
                            ReminderCell(name: friend.name, frequency: friend.frequency, messaged: friend.messaged, editCommit: { selectedID = friend.id; withAnimation { self.isShowingPicker.toggle() } }, buttonCommit: {self.presentMessageCompose(name: friend.name, phoneNumber: friend.id)})
                        }
                    }
                }
                .padding(.top, Space.rSpaceTwo)
                Spacer()
            }
        }
        .pickerView(isShowing: self.$isShowingPicker, commitChanges: self.$commitChanges, picked: self.$selectedFrequencyIndex, title: "Change Frequency", options: self.$frequencyOptions)
        .onChange(of: commitChanges) { _ in
            if (commitChanges) {
                self.changeFrequency(phoneNumber: self.selectedID, frequency: self.frequencyOptions[self.selectedFrequencyIndex])
            }
        }
        .hideNavigationBar()
        .onAppear() {
            self.getReminders()
        }
    }
            
    func getReminders() {
        let staticJSON = UserDefaults.standard.bool(forKey: "useStaticJSON")

        friendReminders = [ReminderProfile]()
        oskiProfile = OskiProfile(health: "", image: "", score: 0)

        let parameters = [
            "user_id": UserDefaults.standard.string(forKey: "phoneNumber")
        ]
        let headers : HTTPHeaders = ["Content-Type": "application/json"]

        if staticJSON {
            AF.request("https://raw.githubusercontent.com/IrisHub/iris-3-endpoint-responses/master/reminders.json", method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                do {
                    let json = try JSON(data: response.data ?? Data())
                    self.frequencyOptions = json["options"].arrayValue.map { $0.stringValue }
                    for (_,subJson):(String, JSON) in json["friend_states"] {
                        let item = ReminderProfile(id: subJson["id"].stringValue, name: subJson["name"].stringValue, emoji: "".randomEmoji(), messaged: subJson["messaged"].boolValue, frequency: subJson["frequency"].stringValue)
                        self.friendReminders.append(item)
                    }
                    let convertedStr = json["oski_state"]["img"].stringValue.replacingOccurrences(of: "\\/", with: "/")
                    self.oskiProfile = OskiProfile(health: json["oski_state"]["health"].stringValue, image: convertedStr, score: json["oski_state"]["score"].intValue)
                } catch {
                    print("error")
                }
            }
        } else {
            AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/reminders-info", method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                do {
                    let json = try JSON(data: response.data ?? Data())
                    self.frequencyOptions = json["options"].arrayValue.map { $0.stringValue }
                    print(self.frequencyOptions)
                    print(json)
                    for (_,subJson):(String, JSON) in json["friend_states"] {
                        let item = ReminderProfile(id: subJson["id"].stringValue, name: subJson["name"].stringValue, emoji: "".randomEmoji(), messaged: subJson["messaged"].boolValue, frequency: subJson["frequency"].stringValue)
                        self.friendReminders.append(item)
                    }
                    let convertedStr = json["oski_state"]["img"].stringValue.replacingOccurrences(of: "\\/", with: "/")
                    self.oskiProfile = OskiProfile(health: json["oski_state"]["health"].stringValue, image: convertedStr, score: json["oski_state"]["score"].intValue)
                } catch {
                    print("error")
                }
            }
        }
    }
    
    func changeUserSettings(phoneNumber: String, frequency: String = "") {
        if (UserDefaults.standard.bool(forKey: "useStaticJSON")) { return }
        let parameters = [
            "user_id": UserDefaults.standard.string(forKey: "phoneNumber"),
            "friend_id": phoneNumber,
            "frequency": frequency
        ]
        let headers : HTTPHeaders = ["Content-Type": "application/json"]
        print(parameters)
        AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/reminders-info", method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
            do {
                let json = try JSON(data: response.data ?? Data())
                self.frequencyOptions = json["options"].arrayValue.map { $0.stringValue }

                print(json)
                for (_,subJson):(String, JSON) in json["friend_states"] {
                    let friend = ReminderProfile(id: subJson["id"].stringValue, name: subJson["name"].stringValue, emoji: "".randomEmoji(), messaged: subJson["messaged"].boolValue, frequency: subJson["frequency"].stringValue)
                    if (friend.id == phoneNumber) {
                        self.friendReminders[self.friendReminders.firstIndex(where: {$0.id == phoneNumber}) ?? 0] = friend
                    }
                }
                let convertedStr = json["oski_state"]["img"].stringValue.replacingOccurrences(of: "\\/", with: "/")
                self.oskiProfile = OskiProfile(health: json["oski_state"]["health"].stringValue, image: convertedStr, score: json["oski_state"]["score"].intValue)
            } catch {
                print("error")
            }
        }
    }
    
    func changeFrequency(phoneNumber: String, frequency: String) {
        self.changeUserSettings(phoneNumber: phoneNumber, frequency: frequency)
        
        // Reset everything
        self.selectedID = ""
        self.selectedFrequencyIndex = 0
        self.commitChanges = false
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
        self.changeUserSettings(phoneNumber: phoneNumber)

        vc?.present(composeVC, animated: true, completion: nil)
    }
}
