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
//    @Binding var currentCardState: String?
    @EnvironmentObject var screenCoordinator: ScreenCoordinator

    @State var calendarAllowed: Bool = false
    @State var contactsAllowed: Bool = false
    @State var bothAllowed: Bool = false
    @State var nextPage : String? = nil
    @State var selectionNumber : Int? = nil
    
    @State var card : Card
    @State var searchText : String?
    
    @State var contacts: [Contact] = [Contact]()
    
    @State var finishedAuth: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                TopNavigationHeader(heading: card.heading, title: card.name, description: card.description, backButton: true, backButtonCommit: { self.presentationMode.wrappedValue.dismiss() })
                
                
                if (self.card.permissions.contains(.calendar)) {
                    retinaLeftButton(text: "ALLOW ACCESS TO CALENDAR", left: .image, iconString: "calendar_logo", checked: (self.googleDelegate.signedIn || self.calendarAllowed) ? true : false, action: {
                        DispatchQueue.main.async {
                            GIDSignIn.sharedInstance().delegate = self.googleDelegate
                            GIDSignIn.sharedInstance().signIn()
                        }
                    })
                }

                if (self.card.permissions.contains(.contacts)) {
                    retinaLeftButton(text: "ALLOW ACCESS TO CONTACTS", left: .image, iconString: "contacts_logo", checked: self.contactsAllowed ? true : false, action: {
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
                    retinaLeftButton(text: "NO PERMISSIONS NEEDED", left: retinaLeftButton.Left.none, checked: false, action: {
                    })
                }
                
                if (!self.card.permissions.contains(.none)) {
                    HStack {
                        Text("How we protect your").retinaTypography(.p6_main).foregroundColor(.rWhite).fixedSize(horizontal: false, vertical: true)
                        NavigationLink(destination: InformationView(type: .privacy).environmentObject(self.screenCoordinator), tag: "privacy", selection: self.$nextPage) {
                            Text("Privacy").underline().retinaTypography(.p6_main).foregroundColor(.rWhite).fixedSize(horizontal: false, vertical: true)
                        }
                        Text("🐻").retinaTypography(.p6_main).fixedSize(horizontal: false, vertical: true)
                    }
                    .shadow(color: .rBlack500, radius: 10)
                    .padding(.top, 6).padding(.leading, 24)
                }

                Group {
                    NavigationLink(destination: CloseFriends().environmentObject(self.screenCoordinator), tag: "card1", selection: self.$nextPage) { EmptyView() }
                    NavigationLink(destination: ReminderView().environmentObject(self.screenCoordinator), tag: "card2", selection: self.$nextPage) { EmptyView() }
                    NavigationLink(destination: ClassesView().environmentObject(self.screenCoordinator), tag: "card3", selection: self.$nextPage) { EmptyView() }
                    NavigationLink(destination: LecturesView().environmentObject(self.screenCoordinator), tag: "card4", selection: self.$nextPage) { EmptyView() }
                    NavigationLink(destination: CollaborationView().environmentObject(self.screenCoordinator), tag: "card5", selection: self.$nextPage) { EmptyView() }
                    NavigationLink(destination: ChooseCloseFriends(card: self.card, selectionNumber: self.selectionNumber, skipThisController: self.$nextPage).environmentObject(self.screenCoordinator), isActive: $bothAllowed) { EmptyView() }
                }
                Spacer()

                
                BottomNavigationView(title: self.card.buttonTitle, action: {
                    self.refreshPermissions()
                    self.selectionNumber = self.directCorrectly()
                    if (self.selectionNumber == -1) {
                        if self.card.id == "card1" { ChooseCloseFriends(card: self.card, shouldSkipThis: true, skipThisController: self.$nextPage).signUpCard1(); if self.finishedAuth { self.nextPage = "card1"; print("hola!") } }
                        else if self.card.id == "card2" { ChooseCloseFriends(card: self.card, shouldSkipThis: true, skipThisController: self.$nextPage).signUpCard2() }
                        else if self.card.id == "card3" { ChooseCloseFriends(card: self.card, shouldSkipThis: true, skipThisController: self.$nextPage).signUpCard3() }
                        else if self.card.id == "card4" { ChooseCloseFriends(card: self.card, shouldSkipThis: true, skipThisController: self.$nextPage).signUpCard4() }
                        else if self.card.id == "card5" { ChooseCloseFriends(card: self.card, shouldSkipThis: true, skipThisController: self.$nextPage).signUpCard5() }
                    } else {
                        if (self.card.permissions.contains(.calendar) && self.card.permissions.contains(.contacts)) {
                            if self.contactsAllowed && self.googleDelegate.signedIn { self.bothAllowed = true }
                        } else if (self.card.permissions.contains(.calendar)) {
                            if self.googleDelegate.signedIn { self.bothAllowed = true }
                        } else if (self.card.permissions.contains(.contacts)) {
                            if self.contactsAllowed { self.bothAllowed = true }
                        } else if (self.card.permissions.contains(.none)) { self.bothAllowed = true }
                    }
                })
            }
        }
        .onAppear() {
//            if (currentCardState == nil) {
//                self.currentCardState = UserDefaults.standard.string(forKey: "currentCardState")
//            } else {
//                UserDefaults.standard.set(currentCardState, forKey: "currentCardState")
//            }
            self.contactsAllowed = UserDefaults.standard.bool(forKey: "contactsAllowed")
            self.calendarAllowed = UserDefaults.standard.bool(forKey: "calendarAllowed")
        }
        .onReceive(self.googleDelegate.$signedIn) { _ in
//            print(self.currentCardState, "self.currentCardState")
            print("ContentView appeared!")
            self.screenCoordinator.selectedPushItem = .cardpermission
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
