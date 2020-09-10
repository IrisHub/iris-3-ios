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
    @State private var searchText: String? = ""
    @State var allContacts: [Contact]
    @Binding var currentCardState: String?
    
    @State var card : Card
    @State var selectionNumber : Int? = nil
    @State var nextPage : String? = nil

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            Color.rBlack400.edgesIgnoringSafeArea(.all)
            VStack {
                TopNavigationView(title: self.card.selectionScreens[self.selectionNumber ?? 0].title, description: self.card.selectionScreens[self.selectionNumber ?? 0].description, backButton: true, backButtonCommit: { self.presentationMode.wrappedValue.dismiss() }, rightButton: false, searchBar: true, searchBarPlaceholder: "Friends", searchText: self.$searchText)

                List {
                    if (self.card.selectionScreens[self.selectionNumber ?? 0].selection == .contacts) {
                        ForEach(self.allContacts.filter {
                            self.searchText?.filter { !$0.isWhitespace }.isEmpty ?? false ? true : $0.name.lowercased().contains(self.searchText?.lowercased() ?? "")
                        }, id: \.self.name) { (contact: Contact) in
                            SelectionCell(contacts: self.$allContacts, contact: contact, isSingleSelect: false)
                            .listRowInsets(EdgeInsets())
                        }
                    } else if (self.card.selectionScreens[self.selectionNumber ?? 0].selection == .classes) {
                        
                    }
                }

                Spacer()
                
                Group {
                    NavigationLink(destination: CloseFriends(currentCardState: self.$currentCardState, store: self.store), tag: "card1", selection: self.$nextPage) { EmptyView() }.isDetailLink(false)
                    NavigationLink(destination: ReminderView(currentCardState: self.$currentCardState, store: self.store), tag: "card2", selection: self.$nextPage) { EmptyView() }.isDetailLink(false)
                    NavigationLink(destination: ChooseCloseFriends(store: self.store, allContacts: self.store.contacts, currentCardState: self.$currentCardState, card: self.card, selectionNumber: (self.selectionNumber ?? 0)-1), tag: "again", selection: self.$nextPage) { EmptyView() }.isDetailLink(false)
                }
                
                BottomNavigationView(title: "Continue", action: {
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
                })
            }
        }
        .hideNavigationBar()
        .onAppear() {
            if #available(iOS 14.0, *) {} else { UITableView.appearance().tableFooterView = UIView() }
            UITableView.appearance().separatorStyle = .none
            UITableViewCell.appearance().backgroundColor = Color.rBlack400.uiColor()
            UITableView.appearance().backgroundColor = Color.rBlack400.uiColor()
        }

    }
    
    func signUpCard1() {
        struct User: Codable {
            var user_id: String
            var refresh_token: String
            var friend_ids: [String]
            var friend_names: [String]
        }

        do {
            let user = User(user_id: UserDefaults.standard.string(forKey: "phoneNumber") ?? "", refresh_token: UserDefaults.standard.string(forKey: "refreshToken") ?? "", friend_ids: self.allContacts.filter({ $0.selected == true }).map({ $0.phoneNum }), friend_names: self.allContacts.filter({ $0.selected == true }).map({ $0.name }))
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
            var close_friend_names: [String]
            var distant_friend_ids: [String]
            var distant_friend_names: [String]
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

            let user = User(user_id: UserDefaults.standard.string(forKey: "phoneNumber") ?? "", close_friend_ids: (peopleArray[0]).map({ $0.phoneNum }), close_friend_names: (peopleArray[0]).map({ $0.name }), distant_friend_ids: (peopleArray[1]).map({ $0.phoneNum }), distant_friend_names: (peopleArray[1]).map({ $0.name }))
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
