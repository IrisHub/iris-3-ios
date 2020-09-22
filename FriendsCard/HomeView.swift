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

    @State var cards : [Card] = [
        Card(id: "card1", heading: "CARD01 SEPTEMBER19-2020", name: "WHEN2MEET MY CLOSE FRIENDS", searchTitle: "CONTACTS", description: "Know when your friends are free without having to ask.", buttonTitle: "CHOOSE CLOSE FRIENDS", permissions: [.calendar, .contacts], selectionScreens: [
            SelectionScreen(id: "screen1", title: "CHOOSE CLOSE FRIENDS", description: "We’ll tell you when they’re free or busy.", buttonTitle: "CHOOSE CLOSE FRIENDS", selection: .contacts, userDefaultID: "closeFriends")
        ]),
        Card(id: "card2", heading: "CARD02 SEPTEMBER19-2020", name: "SAVE OSKI, SAVE YOUR FRIENDS", searchTitle: "CONTACTS", description: "Keep Oski alive by remembering to text the people you care about.", buttonTitle: "CHOOSE CLOSE FRIENDS", permissions: [.contacts], selectionScreens: [
            SelectionScreen(id: "screen1", title: "CHOOSE CLOSE FRIENDS", description: "We’ll tell you when they’re free or busy.", buttonTitle: "CHOOSE CLOSE FRIENDS", selection: .contacts, userDefaultID: "closeFriends")
        ]),
        Card(id: "card3", heading: "CARD03 SEPTEMBER19-2020", name: "\"HOW LONG IS THE HOMEWORK?\"", searchTitle: "CLASSES", description: "How long the homework actually takes.", buttonTitle: "CHOOSE YOUR CLASSES", permissions: [.none], selectionScreens: [
            SelectionScreen(id: "screen1", title: "CHOOSE YOUR CLASSES", description: "Right now, we only support classes that are on Piazza.  We’re adding more each day.", buttonTitle: "CHOOSE YOUR CLASSES", selection: .classes, userDefaultID: "classes")
        ]),
        Card(id: "card4", heading: "CARD04 SEPTEMBER19-2020", name: "FINESSE THE LECTURE", searchTitle: "CLASSES", description: "Share with your peers what lectures to watch when.", buttonTitle: "CHOOSE YOUR CLASSES", permissions: [.none], selectionScreens: [
            SelectionScreen(id: "screen1", title: "CHOOSE YOUR CLASSES", description: "Right now, we only support classes that are on Berkeley Time.  We’re adding more each day.", buttonTitle: "CHOOSE YOUR CLASSES", selection: .classes, userDefaultID: "classes")
        ]),
        Card(id: "card5", heading: "CARD05 SEPTEMBER19-2020", name: "VIRTUAL STUDY GROUP", searchTitle: "CLASSES", description: "Collab when your study group isn’t responding, or doesn’t exist.", buttonTitle: "Choose Classes", permissions: [.none], selectionScreens: [
            SelectionScreen(id: "screen1", title: "CHOOSE YOUR CLASSES", description: "Right now, we only support classes that are on Berkeley Time.  We’re adding more each day.", buttonTitle: "CHOOSE YOUR CLASSES", selection: .classes, userDefaultID: "classes")
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
            Color.rBlack400.edgesIgnoringSafeArea(.all)
            
            HStack {
                VStack {
                    Group {
                        NavigationLink(destination: PermissionsView(card: self.cards[self.cardNumber ?? 0]).environmentObject(self.googleDelegate).environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.cardpermission, selection: self.$screenCoordinator.selectedPushItem) { EmptyView() }

                        NavigationLink(destination: CloseFriends().environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.card1, selection: self.$screenCoordinator.selectedPushItem) { EmptyView() }

                        NavigationLink(destination: ReminderView().environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.card2, selection: self.$screenCoordinator.selectedPushItem) { EmptyView() }
                        
                        NavigationLink(destination: ClassesView().environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.card3, selection: self.$screenCoordinator.selectedPushItem) { EmptyView() }
                        
                        NavigationLink(destination: LecturesView().environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.card4, selection: self.$screenCoordinator.selectedPushItem) { EmptyView() }
                        
                        NavigationLink(destination: CollaborationView().environmentObject(self.screenCoordinator), tag: ScreenCoordinator.PushedItem.card5, selection: self.$screenCoordinator.selectedPushItem) { EmptyView() }
                    }
                    
                    ScrollView(showsIndicators: false) {
                        Image("heart").padding(.top, 48)

                        HStack {
                            Text("PACK03: " + countDownString()).retinaTypography(.h4_main).foregroundColor(.rPink).padding([.leading, .top], 24)
                                .fixedSize(horizontal: false, vertical: true)
                                .onAppear(perform: {
                                    _ = self.timer
                                })

                            Spacer()
                        }

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
                        
                        retinaLeftButton(text: "SAVE OSKI, SAVE YOUR FRIENDSHIP  ", left: retinaLeftButton.Left.none, iconString: "", action: {
                            DispatchQueue.main.async {
                                self.logInCardTwo()
                            }
                        })
                        
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
        if (UserDefaults.standard.bool(forKey: "card1PermissionsComplete") == true) {
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            self.screenCoordinator.selectedPushItem = .card1
        } else {
            self.screenCoordinator.selectedPushItem = .cardpermission
        }
    }
    
    func logInCardTwo() {
        self.cardNumber = 1
        if (UserDefaults.standard.bool(forKey: "card2PermissionsComplete") == true) {
            self.screenCoordinator.selectedPushItem = .card2
        } else {
            self.screenCoordinator.selectedPushItem = .cardpermission
        }
    }
    
    func logInCardThree() {
        self.cardNumber = 2
        if (UserDefaults.standard.bool(forKey: "card3PermissionsComplete") == true) {
            self.screenCoordinator.selectedPushItem = .card3
        } else {
            self.screenCoordinator.selectedPushItem = .cardpermission
        }
    }
    
    func logInCardFour() {
        self.cardNumber = 3
        if (UserDefaults.standard.bool(forKey: "card4PermissionsComplete") == true) {
            self.screenCoordinator.selectedPushItem = .card4
        } else {
            self.screenCoordinator.selectedPushItem = .cardpermission
        }
    }
    
    func logInCardFive() {
        self.cardNumber = 4
        if (UserDefaults.standard.bool(forKey: "card5PermissionsComplete") == true) {
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

//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
