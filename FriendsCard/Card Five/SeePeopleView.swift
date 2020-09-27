//
//  SeePeopleView.swift
//  FriendsCard
//
//  Created by Shalin on 9/17/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import MessageUI

struct SeePeopleView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var className: String
    @State var assignmentName: String
    
    @State var classID: String
    @State var assignmentID: String
    
    @State var broadcasters: [Broadcaster] = [Broadcaster]()
    @State var assignments: [Assignments] = [Assignments]()
    @State var name: String
    @State var avatar: String
    @State var tags: String
    @State var searchText : String?
    
    @State private var isShowingAlert = false
    @State private var alertInput = ""
    @State var commitChanges = false
    
    // The delegate required by `MFMessageComposeViewController`
    private let messageComposeDelegate = MessageComposerDelegate()
    
    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack {
                TopNavigationView(title: assignmentName + ", " + className, description: "", backButton: true, backButtonCommit: { self.presentationMode.wrappedValue.dismiss() }, rightButton: false, searchBar: false, searchText: self.$searchText)
                .padding(.bottom, 24)
                
                BroadcastCell(name: self.name, emoji: self.avatar, badgeTitle: self.tags.isEmpty ? " I need help on..." : self.tags, isCurrentUser: true, editBroadcast: {
                    withAnimation {
                        self.isShowingAlert.toggle()
                    }
                }).padding(.bottom, 36)
                
                Divider().frame(height: 1).background(Color.rBlack200)
                .padding(.bottom, 36)

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if (self.broadcasters.count != 0) {
                            Text("Needs help on").foregroundColor(.rWhite).retinaTypography(.p4_main).fixedSize(horizontal: false, vertical: true)
                            .padding([.leading, .bottom], 24)
                        }
                        
                        ForEach(self.broadcasters, id: \.self) { (broadcaster: Broadcaster) in
                            Button(action: {
                                DispatchQueue.main.async {
                                    self.presentMessageCompose(phoneNumber: broadcaster.id)
                                }
                            }) {
                                BroadcastCell(name: broadcaster.name, emoji: broadcaster.icon, badgeTitle: broadcaster.tags, isCurrentUser: false, editBroadcast: {
                                    DispatchQueue.main.async {
                                        self.presentMessageCompose(phoneNumber: broadcaster.id)
                                    }
                                })
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .textFieldAlert(isShowing: $isShowingAlert, commitChanges: self.$commitChanges, text: $alertInput, title: "What do you need help on?")
        .onChange(of: commitChanges) { _ in
            if (commitChanges) {
                self.broadcast(classID: self.classID, assignmentID: self.assignmentID, broadcastTags: self.alertInput)
            }
        }
        .hideNavigationBar()
    }
    
    func broadcast(classID: String, assignmentID: String, broadcastTags: String) {
        if (UserDefaults.standard.bool(forKey: "useStaticJSON")) { return }
        print("New tags", broadcastTags)
        let parameters = [
            "user_id": UserDefaults.standard.string(forKey: "phoneNumber"),
            "class_id": classID,
            "assignment_id": assignmentID,
            "broadcast_tags": broadcastTags
        ]
        
        let headers : HTTPHeaders = ["Content-Type": "application/json"]
        print(parameters)
        AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/collaboration-classes-info", method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
            do {
                let json = try JSON(data: response.data ?? Data())
                for (_,subJson):(String, JSON) in json["classes"] {
                    if (subJson["class_id"].stringValue == classID) {
                        for (_,subJson2):(String, JSON) in subJson["assignments"] {
                            if (subJson2["assignment_id"].stringValue == assignmentID) {
                                self.name = subJson2["current_user_broadcast_name"].stringValue
                                self.avatar = subJson2["current_user_broadcast_icon"].stringValue
                                self.tags = subJson2["current_user_broadcast_tags"].stringValue
                                print(self.tags)
                            }
                        }
                    }
                }
            } catch {
                print("error")
            }
        }
        
        // Reset everything
        self.alertInput = ""
        self.commitChanges = false
    }
}


extension SeePeopleView {
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
    private func presentMessageCompose(phoneNumber: String) {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = messageComposeDelegate
        composeVC.body = "hey "
        composeVC.recipients = [phoneNumber]

        DispatchQueue.main.async {
            vc?.present(composeVC, animated: true, completion: nil)
        }
    }
}
