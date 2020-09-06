//
//  ChooseDistantFriends.swift
//  FriendsCard
//
//  Created by Shalin on 9/4/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import Contacts

struct ChooseDistantFriends: View {
    @ObservedObject var store: ContactStore
    @State private var searchText = ""
    @State var allContacts: [Contact]
    @State var closeFriends: [Contact]
    @State var moveToNext: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.rBlack400.edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    Group {
                        Text("Choose Distant Friends")
                            .retinaTypography(.h4_secondary)
                            .foregroundColor(.white)
                        .padding(.leading, 24)
                        .padding(.top, UIApplication.topInset*2)
                        
                        Text("We all have a handful of people we know we should contact, but we don’t really know how to.  Choose who these people are for you, and this card will help you break the ice.").retinaTypography(.p5_main).foregroundColor(.rGrey100)

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
                            NavigationLink(destination: HomeView(store: self.store, closeFriends: self.closeFriends, distantFriends: self.allContacts.filter({ $0.selected == true })), isActive: $moveToNext) { EmptyView() }
                            retinaButton(text: "Continue", style: .outlineOnly, color: .rPink, action: {
                                DispatchQueue.main.async {
                                    if self.allContacts.filter({ $0.selected == true }).count > 0 {
                                        self.moveToNext = true
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
}

//struct ChooseDistantFriends_Previews: PreviewProvider {
//    static var previews: some View {
//        ChooseDistantFriends()
//    }
//}
