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
    @State var currentCardState: String? = nil
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
                        
                        NavigationLink(destination: PermissionsView(store: self.store, currentCardState: self.$currentCardState).environmentObject(self.googleDelegate), tag: "card1permission", selection: $currentCardState) { EmptyView() }
                        NavigationLink(destination: CloseFriends(currentCardState: self.$currentCardState, store: self.store), tag: "card1", selection: $currentCardState) { EmptyView() }
                        
                        
                        NavigationLink(destination: UserDefaults.standard.bool(forKey: "card2PermissionsComplete") ? ReminderView() : ReminderView(), tag: "card2", selection: $currentCardState) { EmptyView() }
                        
                        retinaButton(text: "Friends Card", style: .outlineOnly, color: .rPink, action: {
                            DispatchQueue.main.async {
                                self.logInCardOne()
                            }
                        }).frame(width: UIScreen.screenWidth-48, height: 36, alignment: .trailing)

                        retinaButton(text: "Reminder Card", style: .outlineOnly, color: .rPink, action: {
                            DispatchQueue.main.async {
                                self.currentCardState = "card2"
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
        if (UserDefaults.standard.bool(forKey: "card1PermissionsComplete")) {
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            self.store.fetchContacts()
            self.currentCardState = "card1"
        } else {
            self.currentCardState =  "card1permission"
        }
    }
}

//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
