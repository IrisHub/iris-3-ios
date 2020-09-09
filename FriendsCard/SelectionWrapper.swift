//
//  SelectionWrapper.swift
//  FriendsCard
//
//  Created by Shalin on 9/8/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct SelectionWrapper: View {
    @ObservedObject var store: ContactStore
    @State var allContacts: [Contact]
    @Binding var currentCardState: String?
    
    @State var card : Card
    @State var selectionNumber : Int? = nil
    @State var nextPage : String? = nil

    var body: some View {
//        ChooseCloseFriends(store: store, allContacts: self.store.contacts, currentCardState: self.$currentCardState, card: self.card, selectionNumber: (self.selectionNumber ?? 1)-1)
        Text("")
    }
}

//struct SelectionWrapper_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectionWrapper()
//    }
//}
