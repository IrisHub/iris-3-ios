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
import GoogleSignIn

struct CloseFriends: View {
    @ObservedObject var store: ContactStore
    @ObservedObject var observer: Observer = Observer()
    @State var selectedContacts: [Contact]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // The delegate required by `MFMessageComposeViewController`
    private let messageComposeDelegate = MessageDelegate()
    
    // string.filter("0123456789.".contains)

    var body: some View {
        NavigationView {
            ZStack {
                Color.rBlack400.edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    HStack {
                        retinaIconButton(image: (Image(systemName: "chevron.left")), action: {
                            withAnimation {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }).padding(24)
                        
                        Text("Close Friends")
                            .retinaTypography(.h4_secondary)
                            .foregroundColor(.white)
                        .padding(.leading, 24)
                        
                        Spacer()
                    }


                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(self.observer.friendSchedules.filter { $0.onIris }, id: \.self) { (contact: CloseFriendSchedule) in
                            
                            StatusCell(name: self.selectedContacts.first(where: {$0.phoneNum.filter("0123456789.".contains).contains(contact.id.filter("0123456789.".contains))})?.name ?? "", status: contact.busy ? "busy" : "free", activity: contact.activity, description: contact.status)
                            .listRowInsets(EdgeInsets())
                        }
                        
                        ForEach(self.observer.friendSchedules.filter { !$0.onIris }, id: \.self) { (contact: CloseFriendSchedule) in
                            InviteCell(name: self.selectedContacts.first(where: {$0.phoneNum.filter("0123456789.".contains).contains(contact.id.filter("0123456789.".contains))})?.name ?? "Shalin", buttonText: "Invite", buttonCommit: {self.presentMessageCompose(name: self.selectedContacts.first(where: {$0.phoneNum.filter("0123456789.".contains).contains(contact.id.filter("0123456789.".contains))})?.name ?? "", phoneNumber: contact.id)})
                            .listRowInsets(EdgeInsets())
                        }
                    }.background(Color.rBlack400)

                    Spacer()

                }
            }
        }
        .hideNavigationBar()
        .onAppear() {
            self.signUp()
            if !UserDefaults.standard.bool(forKey: "onboardingComplete") {
            } else {
            }
        }
    }
    
        func signUp() {
            struct User: Codable {
    //            var userFullName: String
                var user_id: String
                var refresh_token: String
                var friend_ids: [String]
    //            var distantFriendIDs: [String]
            }

            do {
    //            let user = User(userFullName: UserDefaults.standard.string(forKey: "fullName") ?? "", userID: UserDefaults.standard.string(forKey: "phoneNumber") ?? "", userRefreshToken: UserDefaults.standard.string(forKey: "refreshToken") ?? "", closeFriendIDs: self.closeFriends.map({ $0.phoneNum }), distantFriendIDs: self.distantFriends.map({ $0.phoneNum }))
                let user = User(user_id: UserDefaults.standard.string(forKey: "phoneNumber") ?? "", refresh_token: UserDefaults.standard.string(forKey: "refreshToken") ?? "", friend_ids: self.selectedContacts.map({ $0.phoneNum }))
                let jsonData = try JSONEncoder().encode(user)
                let jsonString = String(data: jsonData, encoding: .utf8)!
                print(jsonString)
                
                let parameters = convertToDictionary(text: jsonString)
                let headers : HTTPHeaders = ["Content-Type": "application/json"]
                AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/friends-auth", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON { response in
                        do {
                            let json = try JSON(data: response.data ?? Data())
                            print(json)
                        } catch {  }
                }
            } catch {  }
        }

}


// MARK: The message part
extension CloseFriends {

    // Delegate for view controller as `MFMessageComposeViewControllerDelegate`
    private class MessageDelegate: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            // Change the button title to "Invited"
            controller.dismiss(animated: true)
        }

    }

    // Present an message compose view controller modally in UIKit environment
    private func presentMessageCompose(name: String, phoneNumber: String) {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        let vc = UIApplication.shared.keyWindow?.rootViewController

        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = messageComposeDelegate
        composeVC.body = "Hey " + name + ", I want to add you as a close friend on Iris. Get the app so I can add you."
        composeVC.recipients = [phoneNumber]

        vc?.present(composeVC, animated: true)
    }
}


//struct CloseFriends_Previews: PreviewProvider {
//    static var previews: some View {
//        CloseFriends(selectedContacts: <#Binding<[Contact]>#>)
//    }
//}
