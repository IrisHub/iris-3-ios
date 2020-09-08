//
//  CloseFriends.swift
//  FriendsCard
//
//  Created by Shalin on 8/29/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import MessageUI

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
        .onAppear() {
            self.observer.getSchedules()
        }
        .hideNavigationBar()
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
