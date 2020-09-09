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

    @ObservedObject var store: ContactStore = ContactStore()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // important for the first time -> create an account
    @EnvironmentObject var googleDelegate: GoogleDelegate
    
    @State var cards : [Card] = [
        Card(id: "card1", name: "Close Friends", description: "This card tells you when your close friends are free and helps you stay connected.", buttonTitle: "Choose Close Friends", permissions: [.calendar, .contacts], selectionScreens: [
            SelectionScreen(id: "screen1", title: "Choose Close Friends", description: "We’ll tell you when they’re free or busy.", buttonTitle: "Select", selection: .contacts, userDefaultID: "closeFriends")
        ]),
        Card(id: "card2", name: "Contacts", description: "This card tells you when your close friends are free and helps you stay connected. We all have a handful of people we know we should contact, but we don’t really know how to.", buttonTitle: "Choose Close Friends", permissions: [.contacts], selectionScreens: [
            SelectionScreen(id: "screen1", title: "Choose Close Friends", description: "We’ll tell you when they’re free or busy.", buttonTitle: "Choose contacts", selection: .contacts, userDefaultID: "closeFriends"),
            SelectionScreen(id: "screen2", title: "Choose contacts", description: "Choose who people you could use some help staying in contact with, and this card will help you keep in touch.", buttonTitle: "Select", selection: .contacts, userDefaultID: "distantFriends")
        ]),
        Card(id: "card3", name: "Homework", description: "This card tells you when your close friends are free and helps you stay connected.", buttonTitle: "Choose Classes", permissions: [.none], selectionScreens: [
            SelectionScreen(id: "screen1", title: "Choose your classes", description: "Right now, we only support classes that are on Piazza.  We’re adding more each day.", buttonTitle: "Select", selection: .classes, userDefaultID: "classes")
        ])
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color.rBlack400.edgesIgnoringSafeArea(.all)
                
                HStack {
                    VStack(alignment: .leading) {
                        Group {
                            Text("Home")
                                .retinaTypography(.h4_secondary)
                                .foregroundColor(.white)
                            
                            .padding(.top, UIApplication.topInset)
                        }

                        Spacer()
                        
                        NavigationLink(destination: PermissionsView(store: self.store, currentCardState: self.$currentCardState, card: self.cards[self.cardNumber ?? 0]).environmentObject(self.googleDelegate), tag: "cardpermission", selection: $currentCardState) { EmptyView() }

                        NavigationLink(destination: CloseFriends(currentCardState: self.$currentCardState, store: self.store), tag: "card1", selection: $currentCardState) { EmptyView() }

                        NavigationLink(destination: ReminderView(currentCardState: self.$currentCardState, store: self.store), tag: "card2", selection: $currentCardState) { EmptyView() }

                        
                        retinaButton(text: "Friends Card", style: .outlineOnly, color: .rPink, action: {
                            DispatchQueue.main.async {
                                self.logInCardOne()
                            }
                        }).frame(width: UIScreen.screenWidth-48, height: 36, alignment: .trailing)

                        retinaButton(text: "Reminder Card", style: .outlineOnly, color: .rPink, action: {
                            DispatchQueue.main.async {
                                self.logInCardTwo()
                            }
                        }).frame(width: UIScreen.screenWidth-48, height: 36, alignment: .trailing)
                        
                        retinaButton(text: "Homework Card", style: .outlineOnly, color: .rPink, action: {
                            DispatchQueue.main.async {
                                self.currentCardState = "card3"
                            }
                        }).frame(width: UIScreen.screenWidth-48, height: 36, alignment: .trailing)
                        
                        retinaButton(text: "Lectures Card", style: .outlineOnly, color: .rPink, action: {
                            DispatchQueue.main.async {
                                self.currentCardState = "card4"
                            }
                        }).frame(width: UIScreen.screenWidth-48, height: 36, alignment: .trailing)
                        
                        Spacer()
                        
                    }.padding(.leading, 24)
                    Spacer()
                }
                .background(Color.rBlack400)
            }
        }
        .hideNavigationBar()
    }
    
    func logInCardOne() {
        self.cardNumber = 0
        if (UserDefaults.standard.bool(forKey: "card1PermissionsComplete")) {
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            self.store.fetchContacts()
            self.currentCardState = "card1"
        } else {
            self.currentCardState =  "cardpermission"
        }
    }
    
    func logInCardTwo() {
        self.cardNumber = 1
        if (UserDefaults.standard.bool(forKey: "card2PermissionsComplete")) {
            self.store.fetchContacts()
            self.currentCardState = "card2"
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
