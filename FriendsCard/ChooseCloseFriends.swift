//
//  ChooseFriends.swift
//  FriendsCard
//
//  Created by Shalin on 8/28/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import Contacts
import Alamofire
import SwiftyJSON

struct ChooseCloseFriends: View {
    @ObservedObject var store: ContactStore
    @State private var searchText = ""
    @State var allContacts: [Contact]
    @Binding var currentCardState: String?
    
    @State var card : Card
    @State var selectionNumber : Int? = nil
    @State var nextPage : String? = nil

    
    var body: some View {
        NavigationView {
            ZStack {
                Color.rBlack400.edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    Group {
                        Text(self.card.selectionScreens[self.selectionNumber ?? 0].title)
                            .retinaTypography(.h4_secondary)
                            .foregroundColor(.white)
                        .padding(.leading, 24)
                        .padding(.top, UIApplication.topInset*2)
                        
                        Text(self.card.selectionScreens[self.selectionNumber ?? 0].description).retinaTypography(.p5_main).foregroundColor(.rGrey100)

                        Search(isBack: false, isFilter: true, placeholder: "Friends", searchText: $searchText, buttonCommit:{  })
                    }

                    ScrollView(.vertical, showsIndicators: false) {
                        if (self.card.selectionScreens[self.selectionNumber ?? 0].selection == .contacts) {
                            ForEach(self.allContacts.filter {
                                self.searchText.filter { !$0.isWhitespace }.isEmpty ? true : $0.name.lowercased().contains(self.searchText.lowercased())
                            }, id: \.self.name) { (contact: Contact) in
                                SelectionCell(contacts: self.$allContacts, contact: contact, isSingleSelect: false)
                                .listRowInsets(EdgeInsets())
                            }
                        } else if (self.card.selectionScreens[self.selectionNumber ?? 0].selection == .classes) {
                            
                        }
                    }.background(Color.rBlack400)

                    Spacer()
                    
                    ZStack {
                        Rectangle()
                        .foregroundColor(Color.rBlack200)
                        .frame(width: UIScreen.screenWidth, height: 100)
                        
                            
                        HStack {
                            Group {
                                NavigationLink(destination: CloseFriends(currentCardState: self.$currentCardState, store: self.store), tag: "card1", selection: self.$nextPage) { EmptyView() }
                                NavigationLink(destination: ReminderView(), tag: "card2", selection: self.$nextPage) { EmptyView() }
                                NavigationLink(destination: ChooseCloseFriends(store: self.store, allContacts: self.store.contacts, currentCardState: self.$currentCardState, card: self.card, selectionNumber: (self.selectionNumber ?? 0)-1), tag: "again", selection: self.$nextPage) { EmptyView() }
                            }
                            
                            retinaButton(text: "Continue", style: .outlineOnly, color: .rPink, action: {
                                DispatchQueue.main.async {
                                    if (self.card.selectionScreens[self.selectionNumber ?? 0].selection == .contacts) && self.allContacts.filter({ $0.selected == true }).count < 1 { return }
                                    
                                    if self.card.selectionScreens[self.selectionNumber ?? 0].selection == .contacts {
                                        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allContacts.filter({ $0.selected == true })), forKey:self.card.selectionScreens[self.selectionNumber ?? 0].userDefaultID)
                                    }
                                        
                                    if self.selectionNumber == 0 {
                                        if self.card.id == "card1" {
                                            self.signUpCard1()
                                        } else if self.card.id == "card2" {
                                            self.signUpCard2()
                                        }
                                    } else {
                                        self.nextPage = "again"
                                    }
                                }
                            }).frame(width: UIScreen.screenWidth-48, height: 36, alignment: .trailing)
                        }
                    }
                    .padding(.bottom, DeviceUtility.isIphoneXType ? UIApplication.bottomInset : 0)
                }
            }
        }
        .hideNavigationBar()
    }
    
    func signUpCard1() {
        struct User: Codable {
            var user_id: String
            var refresh_token: String
            var friend_ids: [String]
        }

        do {
            let user = User(user_id: UserDefaults.standard.string(forKey: "phoneNumber") ?? "", refresh_token: UserDefaults.standard.string(forKey: "refreshToken") ?? "", friend_ids: self.allContacts.filter({ $0.selected == true }).map({ $0.phoneNum }))
            let jsonData = try JSONEncoder().encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            
            let parameters = convertToDictionary(text: jsonString)
            let headers : HTTPHeaders = ["Content-Type": "application/json"]
            AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/friends-auth", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                UserDefaults.standard.set(true, forKey: "card1PermissionsComplete")
                self.nextPage = "card1"
            }
        } catch {  }
    }
    
    func signUpCard2() {
        struct User: Codable {
            var user_id: String
            var close_friend_ids: [String]
            var distant_friend_ids: [String]
        }

        do {
            var peopleArray: [[Contact]] = [[Contact]]()
            let sortedScreens = self.card.selectionScreens.sorted { $0.id < $1.id }
            for i in 0..<sortedScreens.count {
                if let data = UserDefaults.standard.value(forKey:sortedScreens[i].userDefaultID) as? Data {
                    let people = (try? PropertyListDecoder().decode(Array<Contact>.self, from: data)) ?? [Contact]()
                    peopleArray.append(people)
                }
            }


            let user = User(user_id: UserDefaults.standard.string(forKey: "phoneNumber") ?? "", close_friend_ids: (peopleArray[0]).map({ $0.phoneNum }), distant_friend_ids: (peopleArray[1]).map({ $0.phoneNum }))
            let jsonData = try JSONEncoder().encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            
            let parameters = convertToDictionary(text: jsonString)
            let headers : HTTPHeaders = ["Content-Type": "application/json"]
            AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/contacts-auth", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                UserDefaults.standard.set(true, forKey: "card2PermissionsComplete")
                self.nextPage = "card2"
            }
        } catch {  }
    }


}

//struct ChooseFriends_Previews: PreviewProvider {
//    static var previews: some View {
//        ChooseFriends(store: <#ContactStore#>, selectedContacts: <#[Contact]#>)
//    }
//}
