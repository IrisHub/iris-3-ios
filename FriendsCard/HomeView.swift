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
    var name : String
    var description: String
    var buttonTitle: String
    var permissions: [Permissions]
    var selectionScreens: [SelectionScreen]
}


struct HomeView: View {
    @State var currentCardState: String? = nil
    @State var cardNumber: Int? = nil
    // important for the first time -> create an account
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @State var searchText : String?

    @State var cards : [Card] = [
        Card(id: "card1", name: "Close Friends", description: "This card tells you when your close friends are free and helps you stay connected.", buttonTitle: "Choose Close Friends", permissions: [.calendar, .contacts], selectionScreens: [
            SelectionScreen(id: "screen1", title: "Choose Close Friends", description: "We’ll tell you when they’re free or busy.", buttonTitle: "Select", selection: .contacts, userDefaultID: "closeFriends")
        ]),
        Card(id: "card2", name: "Contacts", description: "This card tells you when your close friends are free and helps you stay connected. We all have a handful of people we know we should contact, but we don’t really know how to.", buttonTitle: "Choose Close Friends", permissions: [.contacts], selectionScreens: [
            SelectionScreen(id: "screen2", title: "Choose Distant Friends", description: "Choose who people you could use some help staying in contact with, and this card will help you keep in touch.", buttonTitle: "Choose close friends", selection: .contacts, userDefaultID: "distantFriends"),
            SelectionScreen(id: "screen1", title: "Choose Close Friends", description: "We’ll tell you when they’re free or busy.", buttonTitle: "Choose distant friends", selection: .contacts, userDefaultID: "closeFriends")
        ]),
        Card(id: "card3", name: "Homework", description: "This card tells you when your close friends are free and helps you stay connected.", buttonTitle: "Choose Classes", permissions: [.none], selectionScreens: [
            SelectionScreen(id: "screen1", title: "Choose your classes", description: "Right now, we only support classes that are on Piazza.  We’re adding more each day.", buttonTitle: "Select", selection: .classes, userDefaultID: "classes")
        ]),
        Card(id: "card4", name: "Lectures", description: "This card tells you how difficult lectures are, reported by other students.", buttonTitle: "Choose Classes", permissions: [.none], selectionScreens: [
            SelectionScreen(id: "screen1", title: "Choose your classes", description: "Right now, we only support classes that are on Berkeley Time.  We’re adding more each day.", buttonTitle: "Select", selection: .classes, userDefaultID: "classes2")
        ]),
        Card(id: "card5", name: "Collaboration", description: "This card helps you collaborate in a new way with peers in your class.", buttonTitle: "Choose Classes", permissions: [.none], selectionScreens: [
            SelectionScreen(id: "screen1", title: "Choose your classes", description: "Right now, we only support classes that are on Berkeley Time.  We’re adding more each day.", buttonTitle: "Select", selection: .classes, userDefaultID: "classes")
        ])
    ]

    var body: some View {
        ZStack {
            Color.rBlack400.edgesIgnoringSafeArea(.all)
            
            HStack {
                VStack {
                    TopNavigationView(title: "Home", description: "Iris tells you when your close friends are free and helps you stay connected.", backButton: false, rightButton: false, searchBar: false, searchText: self.$searchText)

                    Spacer()
                    
                    Group {
                        NavigationLink(destination: PermissionsView(currentCardState: self.$currentCardState, card: self.cards[self.cardNumber ?? 0]).environmentObject(self.googleDelegate), tag: "cardpermission", selection: $currentCardState) { EmptyView() }.isDetailLink(false)

                        NavigationLink(destination: CloseFriends(currentCardState: self.$currentCardState), tag: "card1", selection: $currentCardState) { EmptyView() }

                        NavigationLink(destination: ReminderView(currentCardState: self.$currentCardState), tag: "card2", selection: $currentCardState) { EmptyView() }
                        
                        NavigationLink(destination: ClassesView(currentCardState: self.$currentCardState), tag: "card3", selection: $currentCardState) { EmptyView() }
                        
                        NavigationLink(destination: LecturesView(currentCardState: self.$currentCardState), tag: "card4", selection: $currentCardState) { EmptyView() }
                        
                        NavigationLink(destination: CollaborationView(currentCardState: self.$currentCardState), tag: "card5", selection: $currentCardState) { EmptyView() }
                    }

                    
                    retinaLeftButton(text: "Friends Card", left: retinaLeftButton.Left.none, iconString: "", action: {
                        DispatchQueue.main.async {
                            self.logInCardOne()
                        }
                    })
                    
                    retinaLeftButton(text: "Reminder Card", left: retinaLeftButton.Left.none, iconString: "", action: {
                        DispatchQueue.main.async {
                            self.logInCardTwo()
                        }
                    })
                    
                    retinaLeftButton(text: "Homework Card", left: retinaLeftButton.Left.none, iconString: "", action: {
                        DispatchQueue.main.async {
                            self.logInCardThree()
                        }
                    })
                    
                    retinaLeftButton(text: "Lectures Card", left: retinaLeftButton.Left.none, iconString: "", action: {
                        DispatchQueue.main.async {
                            self.logInCardFour()
                        }
                    })
                    
                    retinaLeftButton(text: "Collaboration Card", left: retinaLeftButton.Left.none, iconString: "", action: {
                        DispatchQueue.main.async {
                            self.logInCardFive()
                        }
                    })

                    
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
            self.currentCardState = "card1"
        } else {
            self.currentCardState =  "cardpermission"
        }
    }
    
    func logInCardTwo() {
        self.cardNumber = 1
        if (UserDefaults.standard.bool(forKey: "card2PermissionsComplete") == true) {
            self.currentCardState = "card2"
        } else {
            self.currentCardState =  "cardpermission"
        }
    }
    
    func logInCardThree() {
        self.cardNumber = 2
        if (UserDefaults.standard.bool(forKey: "card3PermissionsComplete") == true) {
            self.currentCardState = "card3"
        } else {
            self.currentCardState =  "cardpermission"
        }
    }
    
    func logInCardFour() {
        self.cardNumber = 3
        if (UserDefaults.standard.bool(forKey: "card4PermissionsComplete") == true) {
            self.currentCardState = "card4"
        } else {
            self.currentCardState =  "cardpermission"
        }
    }
    
    func logInCardFive() {
        self.cardNumber = 4
        if (UserDefaults.standard.bool(forKey: "card5PermissionsComplete") == true) {
            self.currentCardState = "card5"
        } else {
            self.currentCardState =  "cardpermission"
        }
    }

}

//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
