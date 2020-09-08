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

struct PermissionsView: View {
    @ObservedObject var store: ContactStore
    @EnvironmentObject var googleDelegate: GoogleDelegate
    
    @State var contactsAllowed: Bool = false
    @State var bothAllowed: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.rBlack400.edgesIgnoringSafeArea(.all)
                VStack {
                    VStack {
                        Text("Welcome").retinaTypography(.h1_secondary).foregroundColor(.rWhite)
                        Text("Iris is your helpful assistant.").retinaTypography(.p5_main).foregroundColor(.rGrey100)
                    }.padding(.top, UIScreen.screenHeight/4)
                    Spacer()
                    
                    retinaButton(text: "Allow access to calendar", style: .outlineOnly, color: .rPink, action: {
                        DispatchQueue.main.async {
                            GIDSignIn.sharedInstance().delegate = self.googleDelegate
                            GIDSignIn.sharedInstance().signIn()
                        }
                    }).frame(width: UIScreen.screenWidth-48, height: 36, alignment: .trailing)

                    retinaButton(text: "Allow access to contacts", style: .outlineOnly, color: .rPink, action: {
                        DispatchQueue.main.async {
                            self.store.fetchContacts()
                            self.contactsAllowed = true
                        }
                    }).frame(width: UIScreen.screenWidth-48, height: 36, alignment: .trailing)
                    
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                        .foregroundColor(Color.rBlack200)
                        .frame(width: UIScreen.screenWidth, height: 100)
                        
                            
                        HStack {
                            NavigationLink(destination: ChooseCloseFriends(store: store, allContacts: self.store.contacts), isActive: $bothAllowed) { EmptyView() }
                            retinaButton(text: "Continue", style: .outlineOnly, color: .rPink, action: {
                                DispatchQueue.main.async {
                                    print(self.googleDelegate.signedIn)
                                    if self.googleDelegate.signedIn && self.contactsAllowed {
                                        self.bothAllowed = true
                                    }
                                }
                            }).frame(width: UIScreen.screenWidth-48, height: 36, alignment: .trailing)
                        }
                    }.padding(.bottom, DeviceUtility.isIphoneXType ? UIApplication.bottomInset : 0)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .hideNavigationBar()
    }
}

//struct PermissionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeView(store: store)
//    }
//}
