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
    @State var moveToNext: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.rBlack400.edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    Group {
                        Text("Choose Close Friends")
                            .retinaTypography(.h4_secondary)
                            .foregroundColor(.white)
                        .padding(.leading, 24)
                        .padding(.top, UIApplication.topInset*2)
                        
                        Text("We’ll tell you when they’re free or busy.").retinaTypography(.p5_main).foregroundColor(.rGrey100)

                        Search(isBack: false, isFilter: true, placeholder: "Friends", searchText: $searchText, buttonCommit:{  })
                    }

                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(self.store.contacts.filter {
                            self.searchText.isEmpty ? true : $0.name.lowercased().contains(self.searchText.lowercased())
                        }, id: \.self.name) { (contact: Contact) in
                            SelectionCell(contacts: self.$allContacts, contact: contact, isSingleSelect: false)
                            .listRowInsets(EdgeInsets())
                        }
                    }.background(Color.rBlack400)

                    Spacer()
                    
                    ZStack {
                        Rectangle()
                        .foregroundColor(Color.rBlack200)
                        .frame(width: UIScreen.screenWidth, height: 100)
                        
                            
                        HStack {
                            NavigationLink(destination: CloseFriends(store: self.store, selectedContacts: self.allContacts.filter({ $0.selected == true })), isActive: $moveToNext) { EmptyView() }
                            
                            retinaButton(text: "Continue", style: .outlineOnly, color: .rPink, action: {
                                DispatchQueue.main.async {
                                    if self.allContacts.filter({ $0.selected == true }).count > 0 {
                                        self.signUp()
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
    
    func signUp() {
        struct User: Codable {
            var user_id: String
            var refresh_token: String
            var friend_ids: [String]
        }

        do {
            let user = User(user_id: UserDefaults.standard.string(forKey: "phoneNumber") ?? "", refresh_token: UserDefaults.standard.string(forKey: "refreshToken") ?? "", friend_ids: self.allContacts.map({ $0.phoneNum }))
            let jsonData = try JSONEncoder().encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            
            let parameters = convertToDictionary(text: jsonString)
            let headers : HTTPHeaders = ["Content-Type": "application/json"]
            AF.request("https://7vo5tx7lgh.execute-api.us-west-1.amazonaws.com/testing/friends-auth", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    do {
                        let json = try JSON(data: response.data ?? Data())
                        print(json)
                        UserDefaults.standard.set(true, forKey: "card1PermissionsComplete")
                        self.moveToNext = true
                    } catch {  }
            }
        } catch {  }
    }

}

//struct ChooseFriends_Previews: PreviewProvider {
//    static var previews: some View {
//        ChooseFriends(store: <#ContactStore#>, selectedContacts: <#[Contact]#>)
//    }
//}
