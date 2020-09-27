//
//  HomeView.swift
//  FriendsCard
//
//  Created by Shalin on 8/29/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import GoogleSignIn
import MessageUI

enum Permissions {
    case none
    case calendar
    case contacts
}

enum Selection {
    case classes
    case contacts
}

struct SelectionScreen {
    var id : String
    var title : String
    var description: String
    var buttonTitle: String
    var selection: Selection
    var userDefaultID: String
}

struct Card {
    var id : String
    var heading : String
    var name : String
    var searchTitle: String
    var description: String
    var buttonTitle: String
    var permissions: [Permissions]
    var selectionScreens: [SelectionScreen]
}


struct HomeView: View {
//    @State var currentCardState: String? = nil
    @State var cardNumber: Int? = nil
    // important for the first time -> create an account
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @State var searchText : String?
    @EnvironmentObject var screenCoordinator: ScreenCoordinator
    
    // The delegate required by `MFMessageComposeViewController`
    private let messageComposeDelegate = MessageDelegate()

    @State var cards : [Card] = [
        Card(id: "card1", heading: "PACK02-CARD01", name: "WHEN2MEET MY CLOSE FRIENDS", searchTitle: "CONTACTS", description: "Know when your friends are free without having to ask.", buttonTitle: "CHOOSE FRIENDS", permissions: [.calendar, .contacts], selectionScreens: [
            SelectionScreen(id: "screen1", title: "CHOOSE FRIENDS", description: "We’ll tell you when they’re free or busy.", buttonTitle: "CHOOSE FRIENDS", selection: .contacts, userDefaultID: "closeFriends")
        ]),
        Card(id: "card2", heading: "PACK02-CARD02", name: "SAVE OSKI, SAVE YOUR FRIENDS", searchTitle: "CONTACTS", description: "Keep Oski alive by remembering to text the people you care about.", buttonTitle: "CHOOSE FRIENDS", permissions: [.contacts], selectionScreens: [
            SelectionScreen(id: "screen1", title: "CHOOSE FRIENDS", description: "We’ll tell you when they’re free or busy.", buttonTitle: "CHOOSE FRIENDS", selection: .contacts, userDefaultID: "closeFriends")
        ]),
        Card(id: "card3", heading: "PACK01-CARD01", name: "\"HOW LONG IS THE HOMEWORK?\"", searchTitle: "CLASSES", description: "How long the homework actually takes.", buttonTitle: "CHOOSE YOUR CLASSES", permissions: [.none], selectionScreens: [
            SelectionScreen(id: "screen1", title: "CHOOSE YOUR CLASSES", description: "Right now, we only support classes that are on Piazza. We’re adding more each day.", buttonTitle: "CHOOSE YOUR CLASSES", selection: .classes, userDefaultID: "classes")
        ]),
        Card(id: "card4", heading: "PACK01-CARD02", name: "FINESSE THE LECTURE", searchTitle: "CLASSES", description: "Share with your peers what lectures to watch when.", buttonTitle: "CHOOSE YOUR CLASSES", permissions: [.none], selectionScreens: [
            SelectionScreen(id: "screen1", title: "CHOOSE YOUR CLASSES", description: "Right now, we only support classes that are on Piazza. We’re adding more each day.", buttonTitle: "CHOOSE YOUR CLASSES", selection: .classes, userDefaultID: "classes")
        ]),
        Card(id: "card5", heading: "PACK01-CARD03", name: "VIRTUAL STUDY GROUP", searchTitle: "CLASSES", description: "Collab when your study group isn’t responding, or doesn’t exist.", buttonTitle: "Choose Classes", permissions: [.none], selectionScreens: [
            SelectionScreen(id: "screen1", title: "CHOOSE YOUR CLASSES", description: "Right now, we only support classes that are on Piazza. We’re adding more each day.", buttonTitle: "CHOOSE YOUR CLASSES", selection: .classes, userDefaultID: "classes")
        ])
    ]
    
    @State var nowDate: Date = Date()
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.nowDate = Date()
        }
    }

    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            
            HStack {
                VStack {
                    Group {
                        NavigationLink(destination: PermissionsView(card: self.cards[self.cardNumber ?? 0]).environmentObject(self.googleDelegate).environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.cardpermission, selection: self.$screenCoordinator.selectedPushItem) { EmptyView() }

                        NavigationLink(destination: CloseFriends().environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.card1, selection: self.$screenCoordinator.selectedPushItem) { EmptyView() }

                        NavigationLink(destination: ReminderView().environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.card2, selection: self.$screenCoordinator.selectedPushItem) { EmptyView() }
                        
                        NavigationLink(destination: ClassesView().environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.card3, selection: self.$screenCoordinator.selectedPushItem) { EmptyView() }
                        
                        NavigationLink(destination: LecturesView().environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.card4, selection: self.$screenCoordinator.selectedPushItem) { EmptyView() }
                        
                        NavigationLink(destination: CollaborationView().environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.card5, selection: self.$screenCoordinator.selectedPushItem) { EmptyView() }
                        
                        
                        NavigationLink(destination: InformationView(type: .privacy).environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.privacy, selection: self.$screenCoordinator.selectedPushItem) { EmptyView() }
                        NavigationLink(destination: InformationView(type: .tos).environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.tos, selection: self.$screenCoordinator.selectedPushItem) { EmptyView() }
                        NavigationLink(destination: InformationView(type: .about).environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.about, selection: self.$screenCoordinator.selectedPushItem) { EmptyView() }
                    }
                    
                    ScrollView(showsIndicators: false) {
                        NavigationLink(destination: AccessCode().environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.founders, selection: self.$screenCoordinator.selectedPushItem) { Image("heart").padding(.top, 48) }
                        
                        Group {
                            HStack {
                                Text("PACK03: " + countDownString()).retinaTypography(.h4_main).foregroundColor(.rPink).padding([.leading, .top], 24)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .onAppear(perform: {
                                        _ = self.timer
                                    })

                                Spacer()
                            }
                        }
                        
                        Group {
                            HStack {
                                Text("PACK02: FRIENDS FOREVER").retinaTypography(.h4_main).foregroundColor(.rWhite).padding([.bottom, .leading, .top], 24)
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                            }

                            retinaLeftButton(text: "WHEN2MEET MY CLOSE FRIENDS", left: retinaLeftButton.Left.none, iconString: "", action: {
                                DispatchQueue.main.async {
                                    self.logInCardOne()
                                }
                            })
                            
                            retinaLeftButton(text: "SAVE OSKI, SAVE YOUR FRIENDSHIP", left: retinaLeftButton.Left.none, iconString: "", action: {
                                DispatchQueue.main.async {
                                    self.logInCardTwo()
                                }
                            })
                        }
                        
                        Group {
                            HStack {
                                Text("PACK01: CROWDSOURCE YOUR CLASSES").retinaTypography(.h4_main).foregroundColor(.rWhite).padding([.bottom, .leading, .top], 24)
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                            }

                            retinaLeftButton(text: "\"HOW LONG IS THE HW?\"", left: retinaLeftButton.Left.none, iconString: "", action: {
                                DispatchQueue.main.async {
                                    self.logInCardThree()
                                }
                            })
                            
                            retinaLeftButton(text: "FINESSE THE LECTURE", left: retinaLeftButton.Left.none, iconString: "", action: {
                                DispatchQueue.main.async {
                                    self.logInCardFour()
                                }
                            })
                            
                            retinaLeftButton(text: "VIRTUAL STUDY GROUP", left: retinaLeftButton.Left.none, iconString: "", action: {
                                DispatchQueue.main.async {
                                    self.logInCardFive()
                                }
                            })
                        }

                        Group {
                            HStack {
                                Text("PACK00: WTF IS IRIS?").retinaTypography(.h4_main).foregroundColor(.rWhite).padding([.bottom, .leading, .top], 24)
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                            }

                            retinaLeftButton(text: "SERIOUSLY, WTF IS IRIS?", left: retinaLeftButton.Left.none, iconString: "", action: {
                                DispatchQueue.main.async {
                                    self.screenCoordinator.selectedPushItem = .about
                                }
                            })
                            
                            retinaLeftButton(text: "SEND FEEDBACK, SLIDE IN DMS", left: retinaLeftButton.Left.none, iconString: "", action: {
                                DispatchQueue.main.async {
                                    self.presentMessageCompose()
                                }
                            })
                            
                            retinaLeftButton(text: "THE POLICY THAT IS PRIVATE", left: retinaLeftButton.Left.none, iconString: "", action: {
                                DispatchQueue.main.async {
                                    self.screenCoordinator.selectedPushItem = .privacy
                                }
                            })

                            retinaLeftButton(text: "THE TERMS OF SERVICÉ", left: retinaLeftButton.Left.none, iconString: "", action: {
                                DispatchQueue.main.async {
                                    self.screenCoordinator.selectedPushItem = .tos
                                }
                            })

                        }
                    }
                    
                    Spacer()
                    
                }
                Spacer()
            }
        }
        .hideNavigationBar()
    }
    
    func logInCardOne() {
        self.cardNumber = 0
        print(UserDefaults.standard.bool(forKey: "card1PermissionsComplete"))
        if (UserDefaults.standard.bool(forKey: "card1PermissionsComplete") || UserDefaults.standard.bool(forKey: "useStaticJSON")) {
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            self.screenCoordinator.selectedPushItem = .card1
        } else {
            self.screenCoordinator.selectedPushItem = .cardpermission
        }
    }
    
    func logInCardTwo() {
        self.cardNumber = 1
        if (UserDefaults.standard.bool(forKey: "card2PermissionsComplete") || UserDefaults.standard.bool(forKey: "useStaticJSON")) {
            self.screenCoordinator.selectedPushItem = .card2
        } else {
            self.screenCoordinator.selectedPushItem = .cardpermission
        }
    }
    
    func logInCardThree() {
        self.cardNumber = 2
        if (UserDefaults.standard.bool(forKey: "card3PermissionsComplete") || UserDefaults.standard.bool(forKey: "useStaticJSON")) {
            self.screenCoordinator.selectedPushItem = .card3
        } else {
            self.screenCoordinator.selectedPushItem = .cardpermission
        }
    }
    
    func logInCardFour() {
        self.cardNumber = 3
        if (UserDefaults.standard.bool(forKey: "card4PermissionsComplete") || UserDefaults.standard.bool(forKey: "useStaticJSON")) {
            self.screenCoordinator.selectedPushItem = .card4
        } else {
            self.screenCoordinator.selectedPushItem = .cardpermission
        }
    }
    
    func logInCardFive() {
        self.cardNumber = 4
        if (UserDefaults.standard.bool(forKey: "card5PermissionsComplete") || UserDefaults.standard.bool(forKey: "useStaticJSON")) {
            self.screenCoordinator.selectedPushItem = .card5
        } else {
            self.screenCoordinator.selectedPushItem = .cardpermission
        }
    }
    
    func countDownString() -> String {
        var components = DateComponents()
        components.year = 2020
        components.month = 10
        components.day = 3
        components.hour = 18
        components.minute = 0
        components.second = 0
        let date = Calendar.current.date(from: components) ?? Date()

        
        let calendar = Calendar(identifier: .gregorian)
        let components2 = calendar
            .dateComponents([.day, .hour, .minute, .second],
                            from: nowDate,
                            to: date)
        return String(format: "%02dD %02dH %02dM %02dS",
                      components2.day ?? 00,
                      components2.hour ?? 00,
                      components2.minute ?? 00,
                      components2.second ?? 00)
    }

}

// MARK: The message part
extension HomeView {

    /// Delegate for view controller as `MFMessageComposeViewControllerDelegate`
    private class MessageDelegate: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            // Customize here
            controller.dismiss(animated: true)
        }

    }

    /// Present an message compose view controller modally in UIKit environment
    private func presentMessageCompose() {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController

        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = messageComposeDelegate
        composeVC.body = "Hey Iris team, here's my feedback:"
        composeVC.recipients = ["9498362723", "9499396619", "8182033202"]

        vc?.present(composeVC, animated: true)
    }
}


//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
