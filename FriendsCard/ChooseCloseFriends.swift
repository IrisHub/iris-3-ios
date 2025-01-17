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
    @State private var searchText: String? = ""
//    @Binding var currentCardState: String?
    @EnvironmentObject var screenCoordinator: ScreenCoordinator

    @State var card : Card
    @State var selectionNumber : Int? = nil
    
    @State var shouldSkipThis: Bool = false
    @Binding var skipThisController : String?
    @State var nextPage : String? = nil
    
    @State var allContacts: [Contact]? = nil
    @State var classes: [Classes]? = nil

    @State var error: Error? = nil
    
//    @Binding var finishedAuth: Bool

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            Color.rBlack500.edgesIgnoringSafeArea(.all)
            VStack {
                TopNavigationView(title: self.card.selectionScreens[self.selectionNumber ?? 0].title, description: self.card.selectionScreens[self.selectionNumber ?? 0].description, backButton: true, backButtonCommit: { self.presentationMode.wrappedValue.dismiss() }, rightButton: false, searchBar: true, searchBarPlaceholder: self.card.searchTitle, searchText: self.$searchText)

                List {
                    if (self.card.selectionScreens[self.selectionNumber ?? 0].selection == .contacts) && self.allContacts?.count != 0 && self.allContacts != nil {
                        ForEach(self.allContacts!.filter {
                            (self.searchText?.filter { !$0.isWhitespace }.isEmpty ?? false || (self.searchText ?? "").isEmpty) ? true : $0.name.lowercased().contains(self.searchText?.lowercased() ?? "")
                        }, id: \.self.name) { (contact: Contact) in
                            SelectionCell(contacts: self.$allContacts, contact: contact, classes: self.$classes, selectionType: .contacts, isSingleSelect: false)
                            .animation(.none)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    } else if (self.card.selectionScreens[self.selectionNumber ?? 0].selection == .classes) && self.classes?.count != 0 && self.classes != nil {
                        ForEach(self.classes!.filter {
                            (self.searchText?.filter { !$0.isWhitespace }.isEmpty ?? false || (self.searchText ?? "").isEmpty) ? true : $0.name.lowercased().contains(self.searchText?.lowercased() ?? "")
                        }, id: \.self.name) { (currentClass: Classes) in
                            SelectionCell(contacts: self.$allContacts, classes: self.$classes, currentClass: currentClass, selectionType: .classes, isSingleSelect: false)
                            .animation(.none)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                }

                Group {
                    NavigationLink(destination: CloseFriends().environmentObject(self.screenCoordinator), tag: "card1", selection: self.$nextPage) { EmptyView() }
                    NavigationLink(destination: ReminderView().environmentObject(self.screenCoordinator), tag: "card2", selection: self.$nextPage) { EmptyView() }
                    NavigationLink(destination: ClassesView().environmentObject(self.screenCoordinator), tag: "card3", selection: self.$nextPage) { EmptyView() }
                    NavigationLink(destination: LecturesView().environmentObject(self.screenCoordinator), tag: "card4", selection: self.$nextPage) { EmptyView() }
                    NavigationLink(destination: CollaborationView().environmentObject(self.screenCoordinator), tag: "card5", selection: self.$nextPage) { EmptyView() }
                    NavigationLink(destination: ChooseCloseFriends(card: self.card, selectionNumber: (self.selectionNumber ?? 0)-1, skipThisController: self.$skipThisController, nextPage: self.nextPage).environmentObject(self.screenCoordinator), tag: "again", selection: self.$nextPage) { EmptyView() }
                }
                
                BottomNavigationView(title: "Continue", action: {
                    if (self.card.selectionScreens[self.selectionNumber ?? 0].selection == .contacts) && self.allContacts?.filter({ $0.selected == true }).count ?? 0 < 1 { return }
                    
                    if (self.card.selectionScreens[self.selectionNumber ?? 0].selection == .classes) && self.classes?.filter({ $0.selected == true }).count ?? 0 < 1 { return }

                    if self.card.selectionScreens[self.selectionNumber ?? 0].selection == .contacts {
                        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allContacts?.filter({ $0.selected == true })), forKey:self.card.selectionScreens[self.selectionNumber ?? 0].userDefaultID)
                    }
                    
                    if self.card.selectionScreens[self.selectionNumber ?? 0].selection == .classes {
                        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.classes?.filter({ $0.selected == true })), forKey:self.card.selectionScreens[self.selectionNumber ?? 0].userDefaultID)
                    }

                        
                    if self.selectionNumber == 0 {
                        if self.card.id == "card1" { self.signUpCard1() }
                        else if self.card.id == "card2" { self.signUpCard2() }
                        else if self.card.id == "card3" { self.signUpCard3() }
                        else if self.card.id == "card4" { self.signUpCard4() }
                        else if self.card.id == "card5" { self.signUpCard5() }
                    } else {
                        if UserDefaults.standard.data(forKey:self.card.selectionScreens[(self.selectionNumber ?? 0) - 1].userDefaultID) != nil {
                            if self.card.id == "card1" { self.signUpCard1() }
                            else if self.card.id == "card2" { self.signUpCard2() }
                            else if self.card.id == "card3" { self.signUpCard3() }
                            else if self.card.id == "card4" { self.signUpCard4() }
                            else if self.card.id == "card5" { self.signUpCard5() }
                        } else {
                            self.nextPage = "again"
                        }
                    }
                })
            }
        }
        .hideNavigationBar()
        .onAppear() {
            if (self.card.selectionScreens[self.selectionNumber ?? 0].selection == .contacts) {
                self.fetchContacts()
            } else if (self.card.selectionScreens[self.selectionNumber ?? 0].selection == .classes) {
                if (self.card.selectionScreens[self.selectionNumber ?? 0].userDefaultID == "classes") {
                    self.fetchClasses()
                }
            }
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
            var peopleArray: [[Contact]] = [[Contact]]()
            let sortedScreens = self.card.selectionScreens.sorted { $0.id < $1.id }
            for i in 0..<sortedScreens.count {
                if let data = UserDefaults.standard.value(forKey:sortedScreens[i].userDefaultID) as? Data {
                    let people = (try? PropertyListDecoder().decode(Array<Contact>.self, from: data)) ?? [Contact]()
                    peopleArray.append(people)
                }
            }

            let user = User(user_id: UserDefaults.standard.string(forKey: "phoneNumber") ?? "", refresh_token: UserDefaults.standard.string(forKey: "refreshToken") ?? "", friend_ids: (peopleArray[0]).map({ $0.phoneNum }), friend_names: (peopleArray[0]).map({ $0.name }))
            let jsonData = try JSONEncoder().encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            
            let parameters = convertToDictionary(text: jsonString)
            let headers : HTTPHeaders = ["Content-Type": "application/json"]
            AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/friends-auth", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                UserDefaults.standard.set(true, forKey: "card1PermissionsComplete")
                self.nextPage = "card1"
                if shouldSkipThis { self.skipThisController = "card1" }
            }
        } catch {  }
    }
    
    func signUpCard2() {
        struct User: Codable {
            var user_id: String
            var friend_ids: [String]
            var friend_names: [String]
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

            let user = User(user_id: UserDefaults.standard.string(forKey: "phoneNumber") ?? "", friend_ids: (peopleArray[0]).map({ $0.phoneNum }), friend_names: (peopleArray[0]).map({ $0.name }))
            let jsonData = try JSONEncoder().encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            
            let parameters = convertToDictionary(text: jsonString)
            let headers : HTTPHeaders = ["Content-Type": "application/json"]
            AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/reminders-auth", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                UserDefaults.standard.set(true, forKey: "card2PermissionsComplete")
                self.nextPage = "card2"
                if shouldSkipThis { self.skipThisController = "card2" }
            }
        } catch {  }
    }
    
    func signUpCard3() {
        struct User: Codable {
            var user_id: String
            var class_ids: [String]
            var class_names: [String]
        }

        do {
            var classesArray: [[Classes]] = [[Classes]]()
            let sortedScreens = self.card.selectionScreens.sorted { $0.id < $1.id }
            for i in 0..<sortedScreens.count {
                if let data = UserDefaults.standard.value(forKey:sortedScreens[i].userDefaultID) as? Data {
                    let (currentClass) = (try? PropertyListDecoder().decode(Array<Classes>.self, from: data)) ?? [Classes]()
                    classesArray.append(currentClass)
                }
            }

            let user = User(user_id: UserDefaults.standard.string(forKey: "phoneNumber") ?? "", class_ids: (classesArray[0]).map({ $0.id }), class_names: (classesArray[0]).map({ $0.name }))
            let jsonData = try JSONEncoder().encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            
            let parameters = convertToDictionary(text: jsonString)
            let headers : HTTPHeaders = ["Content-Type": "application/json"]
            AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/homework-auth", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                UserDefaults.standard.set(true, forKey: "card3PermissionsComplete")
                self.nextPage = "card3"
                if shouldSkipThis { self.skipThisController = "card3" }
            }
        } catch {  }
    }
        
    func signUpCard4() {
        struct User: Codable {
            var user_id: String
            var class_ids: [String]
            var class_names: [String]
        }

        do {
            var classesArray: [[Classes]] = [[Classes]]()
            let sortedScreens = self.card.selectionScreens.sorted { $0.id < $1.id }
            for i in 0..<sortedScreens.count {
                if let data = UserDefaults.standard.value(forKey:sortedScreens[i].userDefaultID) as? Data {
                    let (currentClass) = (try? PropertyListDecoder().decode(Array<Classes>.self, from: data)) ?? [Classes]()
                    classesArray.append(currentClass)
                }
            }

            let user = User(user_id: UserDefaults.standard.string(forKey: "phoneNumber") ?? "", class_ids: (classesArray[0]).map({ $0.id }), class_names: (classesArray[0]).map({ $0.name }))
            let jsonData = try JSONEncoder().encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            
            let parameters = convertToDictionary(text: jsonString)
            let headers : HTTPHeaders = ["Content-Type": "application/json"]
            AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/lectures-auth", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                UserDefaults.standard.set(true, forKey: "card4PermissionsComplete")
                self.nextPage = "card4"
                if shouldSkipThis { self.skipThisController = "card4" }
            }
        } catch {  }
    }
    
    func signUpCard5() {
        struct User: Codable {
            var user_id: String
            var class_ids: [String]
            var class_names: [String]
        }

        do {
            var classesArray: [[Classes]] = [[Classes]]()
            let sortedScreens = self.card.selectionScreens.sorted { $0.id < $1.id }
            for i in 0..<sortedScreens.count {
                if let data = UserDefaults.standard.value(forKey:sortedScreens[i].userDefaultID) as? Data {
                    let (currentClass) = (try? PropertyListDecoder().decode(Array<Classes>.self, from: data)) ?? [Classes]()
                    classesArray.append(currentClass)
                }
            }

            let user = User(user_id: UserDefaults.standard.string(forKey: "phoneNumber") ?? "", class_ids: (classesArray[0]).map({ $0.id }), class_names: (classesArray[0]).map({ $0.name }))
            let jsonData = try JSONEncoder().encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            
            let parameters = convertToDictionary(text: jsonString)
            let headers : HTTPHeaders = ["Content-Type": "application/json"]
            AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/collaboration-auth", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                UserDefaults.standard.set(true, forKey: "card5PermissionsComplete")
                self.nextPage = "card5"
                if shouldSkipThis { self.skipThisController = "card5" }
            }
        } catch {  }
    }


    
     func fetchContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            
            if granted {
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                request.sortOrder = .givenName
                
                do {
                    var contactsArray = [Contact]()
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        if (contact.phoneNumbers.first?.value.stringValue) != nil && (contact.name.trimmingCharacters(in: .whitespacesAndNewlines)) != "" {
                            contactsArray.append(Contact(id: contact.identifier, name: contact.name, phoneNum: contact.phoneNumbers.first?.value.stringValue ?? "", emoji: "".randomEmoji(), selected: false))
                            print(contact.name)
                        }
                    })
                    
                    DispatchQueue.main.async {
                        self.allContacts = contactsArray
                    }
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
    }
    
    
    func fetchClasses() {
        self.classes = [Classes]()
        
        let headers : HTTPHeaders = ["Content-Type": "application/json"]
        AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/homework-classes-list", method: .post, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
            do {
                let json = try JSON(data: response.data ?? Data())
                for (_,subJson):(String, JSON) in json["classes"] {
                    let currentClass = Classes(id: subJson["class_id"].stringValue, name: subJson["class_name"].stringValue)
                    self.classes?.append(currentClass)
                }
            } catch {
                print("error")
            }
        }
    }



}

//struct ChooseFriends_Previews: PreviewProvider {
//    static var previews: some View {
//        ChooseFriends(store: <#ContactStore#>, selectedContacts: <#[Contact]#>)
//    }
//}
