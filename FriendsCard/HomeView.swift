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

struct HomeView: View {
    @State private var moveToCard: String? = nil
    @ObservedObject var store: ContactStore = ContactStore()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    // important for the first time -> create an account
    @EnvironmentObject var googleDelegate: GoogleDelegate

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
                        
                        NavigationLink(destination: PermissionsView(store: self.store).environmentObject(self.googleDelegate), tag: "card1permission", selection: $moveToCard) { EmptyView() }
                        NavigationLink(destination: CloseFriends(store: self.store, selectedContacts: [Contact]()).environmentObject(FriendSchedules()), tag: "card1", selection: $moveToCard) { EmptyView() }
                        
                        
                        NavigationLink(destination: UserDefaults.standard.bool(forKey: "card2PermissionsComplete") ? ReminderView() : ReminderView(), tag: "card2", selection: $moveToCard) { EmptyView() }
                        
                        retinaButton(text: "Friends Card", style: .outlineOnly, color: .rPink, action: {
                            DispatchQueue.main.async {
                                self.logInCardOne()
                            }
                        }).frame(width: UIScreen.screenWidth-48, height: 36, alignment: .trailing)

                        retinaButton(text: "Reminder Card", style: .outlineOnly, color: .rPink, action: {
                            DispatchQueue.main.async {
                                self.moveToCard = "card2"
                            }
                        }).frame(width: UIScreen.screenWidth-48, height: 36, alignment: .trailing)
                        
                        retinaButton(text: "Homework Card", style: .outlineOnly, color: .rPink, action: {
                            DispatchQueue.main.async {
                                self.moveToCard = "card3"
                            }
                        }).frame(width: UIScreen.screenWidth-48, height: 36, alignment: .trailing)
                        
                        retinaButton(text: "Lectures Card", style: .outlineOnly, color: .rPink, action: {
                            DispatchQueue.main.async {
                                self.moveToCard = "card4"
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
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        self.store.fetchContacts()
        self.moveToCard = UserDefaults.standard.bool(forKey: "card1PermissionsComplete") ? "card1" : "card1permission"
    }
}

//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
