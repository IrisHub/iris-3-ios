//
//  ContentView.swift
//  FriendsCard
//
//  Created by Shalin on 8/26/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import GoogleSignIn
import Contacts


struct PermissionsView: View {
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @Binding var currentCardState: String?

    @State var calendarAllowed: Bool = false
    @State var contactsAllowed: Bool = false
    @State var bothAllowed: Bool = false
    @State var nextPage : String? = nil
    @State var selectionNumber : Int? = nil
    
    @State var card : Card
    @State var searchText : String?
    
    @State var contacts: [Contact] = [Contact]()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            Color.rBlack400.edgesIgnoringSafeArea(.all)
            VStack {
                TopNavigationView(title: card.name, description: card.description, backButton: true, backButtonCommit: { self.presentationMode.wrappedValue.dismiss() }, rightButton: false, searchBar: false, searchText: self.$searchText)
                
                Spacer()
                
                if (self.card.permissions.contains(.calendar)) {
                    retinaLeftButton(text: "Allow access to calendar", left: .image, iconString: "calendar_logo", checked: (self.googleDelegate.signedIn || self.calendarAllowed) ? true : false, action: {
                        DispatchQueue.main.async {
                            GIDSignIn.sharedInstance().delegate = self.googleDelegate
                            GIDSignIn.sharedInstance().signIn()
                        }
                    })
                }

                if (self.card.permissions.contains(.contacts)) {
                    retinaLeftButton(text: "Allow access to contacts", left: .image, iconString: "contacts_logo", checked: self.contactsAllowed ? true : false, action: {
                        DispatchQueue.main.async {
                            CNContactStore().requestAccess(for: .contacts) { (granted, error) in
                                if let error = error {
                                    print("failed to request access", error)
                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                    return
                                }
                                if granted {
                                    UserDefaults.standard.set(true, forKey: "contactsAllowed")
                                    self.contactsAllowed = true
                                }
                            }
                        }
                    })
                }
                
                if (self.card.permissions.contains(.none)) {
                    retinaLeftButton(text: "No permissions required", left: retinaLeftButton.Left.none, checked: false, action: {
                    })
                    .disabled(true)
                }

                
                Spacer()
                
                Group {
                    NavigationLink(destination: CloseFriends(currentCardState: self.$currentCardState), tag: "card1", selection: self.$nextPage) { EmptyView() }.isDetailLink(false)
                    NavigationLink(destination: ReminderView(currentCardState: self.$currentCardState), tag: "card2", selection: self.$nextPage) { EmptyView() }.isDetailLink(false)
                    NavigationLink(destination: ChooseCloseFriends(currentCardState: self.$currentCardState, card: self.card, selectionNumber: self.selectionNumber), isActive: $bothAllowed) { EmptyView() }.isDetailLink(false)
                }
                
                BottomNavigationView(title: self.card.buttonTitle, action: {
                    self.refreshPermissions()
                    self.selectionNumber = self.directCorrectly()
                    if (self.selectionNumber == -1) {
                        if self.card.id == "card1" { ChooseCloseFriends(currentCardState: self.$currentCardState, card: self.card).signUpCard1(); self.nextPage = "card1" }
                        else if self.card.id == "card2" { ChooseCloseFriends(currentCardState: self.$currentCardState, card: self.card).signUpCard2(); self.nextPage = "card2" }
                    } else {
                        if (self.card.permissions.contains(.calendar) && self.card.permissions.contains(.contacts)) {
                            if self.contactsAllowed && self.googleDelegate.signedIn { self.bothAllowed = true }
                        } else if (self.card.permissions.contains(.calendar)) {
                            if self.googleDelegate.signedIn { self.bothAllowed = true }
                        } else if (self.card.permissions.contains(.contacts)) {
                            if self.contactsAllowed { self.bothAllowed = true }
                        }
                    }
                })
            }
        }
        .onAppear() {
            self.contactsAllowed = UserDefaults.standard.bool(forKey: "contactsAllowed")
            self.calendarAllowed = UserDefaults.standard.bool(forKey: "calendarAllowed")
        }
        .onReceive(self.googleDelegate.$signedIn) { _ in
            print(self.currentCardState, "self.currentCardState")
            print("ContentView appeared!")
            self.currentCardState = "cardpermission"
        }
        .hideNavigationBar()
    }
    
    func directCorrectly() -> Int {
        if UserDefaults.standard.data(forKey:self.card.selectionScreens[self.card.selectionScreens.count-1].userDefaultID) != nil {
            
            if self.card.selectionScreens.count > 1 {
                return self.card.selectionScreens.count-2
            } else {
                return -1
            }
        }
        return self.card.selectionScreens.count-1
    }
    
    func refreshPermissions() {
        if (self.card.permissions.contains(.calendar)) {
            guard let signIn = GIDSignIn.sharedInstance() else { return }
            if (signIn.hasPreviousSignIn()) { signIn.restorePreviousSignIn() }
        }
    }
}
