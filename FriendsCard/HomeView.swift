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
    @State var friendsCardActive: Bool = false
    @State var reminderCardActive: Bool = false
    @ObservedObject var store: ContactStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    // important for the first time -> create an account
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @State var closeFriends: [Contact] = [Contact]()
    @State var distantFriends: [Contact] = [Contact]()

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
                                            
                        if UserDefaults.standard.bool(forKey: "onboardingComplete") && GIDSignIn.sharedInstance().hasPreviousSignIn() {
                            NavigationLink(destination: WelcomeView().environmentObject(googleDelegate), isActive: $friendsCardActive) { EmptyView() }
                        } else {
                            NavigationLink(destination: WelcomeView().environmentObject(googleDelegate), isActive: $friendsCardActive) { EmptyView() }

//                            NavigationLink(destination: CloseFriends(store: store, selectedContacts: self.$closeFriends), isActive: $friendsCardActive) { EmptyView() }
                            NavigationLink(destination: ReminderView(), isActive: $reminderCardActive) { EmptyView() }
                        }

                        
                        retinaButton(text: "Friends Card", style: .outlineOnly, color: .rPink, action: {
                            DispatchQueue.main.async {
                                self.friendsCardActive = true
                            }
                        }).frame(width: UIScreen.screenWidth-48, height: 36, alignment: .trailing)

                        retinaButton(text: "Reminder Card", style: .outlineOnly, color: .rPink, action: {
                            DispatchQueue.main.async {
                                self.reminderCardActive = true
                            }
                        }).frame(width: UIScreen.screenWidth-48, height: 36, alignment: .trailing)
                        
                        Spacer()
                        
                    }.padding(.leading, 24)
                    Spacer()
                }
                .background(Color.rBlack400)
            }
        }
        .onAppear() {
            if !UserDefaults.standard.bool(forKey: "onboardingComplete") {
                self.signUp()
            } else {
            }
        }
        .hideNavigationBar()
    }
    
    func logIn() {
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        self.store.fetchContacts()
    }
    
    func signUp() {
        struct User: Codable {
//            var userFullName: String
            var user_id: String
            var refresh_token: String
            var friend_ids: [String]
//            var distantFriendIDs: [String]
        }

        do {
//            let user = User(userFullName: UserDefaults.standard.string(forKey: "fullName") ?? "", userID: UserDefaults.standard.string(forKey: "phoneNumber") ?? "", userRefreshToken: UserDefaults.standard.string(forKey: "refreshToken") ?? "", closeFriendIDs: self.closeFriends.map({ $0.phoneNum }), distantFriendIDs: self.distantFriends.map({ $0.phoneNum }))
            let user = User(user_id: UserDefaults.standard.string(forKey: "phoneNumber") ?? "", refresh_token: UserDefaults.standard.string(forKey: "refreshToken") ?? "", friend_ids: self.closeFriends.map({ $0.phoneNum }))
            let jsonData = try JSONEncoder().encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            
            let parameters = convertToDictionary(text: jsonString)
            let headers : HTTPHeaders = ["Content-Type": "application/json"]
            AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/friends-auth", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    UserDefaults.standard.set(true, forKey: "onboardingComplete")
                    do {
                        let json = try JSON(data: response.data ?? Data())
                        print(json)
                    } catch {  }
            }
        } catch {  }
    }
}

//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
