//
//  SelectionCell.swift
//  Iris
//
//  Created by Shalin on 7/18/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import Contacts

struct SelectionCell: View {

    @Binding var contacts: [Contact]?
    var contact: Contact? = nil
    
    @Binding var classes: [Classes]?
    var currentClass: Classes? = nil
    
    var selectionType: Selection
    var isSingleSelect: Bool

    var body: some View {
        Button(action: {
            if (self.contact != nil) {
                if !self.isSingleSelect {
                    if ((self.contacts?.contains(where: {$0.name.lowercased().contains(self.contact?.name.lowercased() ?? "") && $0.selected})) ?? false) {
                        // it was selected before, now unselect it
                        if let location = self.contacts?.firstIndex(where: {$0.name.lowercased() == self.contact?.name.lowercased() && $0.selected}) {
                            self.contacts?[location].selected = false
                        }
                    } else {
                        // it was not selected before, now select it
                        if let location = self.contacts?.firstIndex(where: {$0.name.lowercased() == self.contact?.name.lowercased()}) {
                            self.contacts?[location].selected = true
                        }
                    }
                } else {
                    // set all items to unselected
                    for idx in 0..<(self.contacts?.count ?? 1) {
                        self.contacts?[idx].selected = false
                    }
                    
                    // set current one to selected
                    if let location = self.contacts?.firstIndex(where: {$0.name.lowercased() == self.contact?.name.lowercased()}) {
                        self.contacts?[location].selected = true
                    }
                }
            } else {
                if !self.isSingleSelect {
                    if ((self.classes?.contains(where: {$0.name.lowercased().contains(self.currentClass?.name.lowercased() ?? "") && $0.selected})) ?? false) {
                        // it was selected before, now unselect it
                        if let location = self.classes?.firstIndex(where: {$0.name.lowercased() == self.currentClass?.name.lowercased() && $0.selected}) {
                            self.classes?[location].selected = false
                        }
                    } else {
                        // it was not selected before, now select it
                        if let location = self.classes?.firstIndex(where: {$0.name.lowercased() == self.currentClass?.name.lowercased()}) {
                            self.classes?[location].selected = true
                        }
                    }
                } else {
                    // set all items to unselected
                    for idx in 0..<(self.classes?.count ?? 1) {
                        self.classes?[idx].selected = false
                    }
                    
                    // set current one to selected
                    if let location = self.classes?.firstIndex(where: {$0.name.lowercased() == self.currentClass?.name.lowercased()}) {
                        self.classes?[location].selected = true
                    }
                }
            }
        }) {
            ZStack(alignment: .leading) {
                Rectangle().frame(width: UIScreen.screenWidth, height: 60).foregroundColor(.rBlack400)
                HStack {
                    if (self.contact != nil) {
                        ZStack {
                            Rectangle()
                            .frame(width: 28, height: 28)
                            .border(Color.rBlack100, width: 2)
                            .foregroundColor(self.contacts?.contains(where: {$0.name.lowercased() == self.contact?.name.lowercased() && $0.selected}) ?? false ? .rBlack100 : .clear)
                            .cornerRadius(2)
                            
                            Image(systemName: "checkmark")
                            .retinaTypography(.h5_main)
                            .font(Font.title.weight(.black))
                            .foregroundColor(self.contacts?.contains(where: {$0.name.lowercased() == self.contact?.name.lowercased() && $0.selected}) ?? false ? .rWhite : .clear)
                            
                        }
                        .padding(.leading, 24)
                            
                        
                        Text(contact?.name.capitalizingFirstLetter() ?? "").foregroundColor(.white).retinaTypography(.h5_main).fixedSize(horizontal: false, vertical: true).frame(width: 204, alignment: .leading).padding(.leading, 12)
                    } else {
                        ZStack {
                            Rectangle()
                            .frame(width: 28, height: 28)
                            .border(Color.rBlack100, width: 2)
                            .foregroundColor(self.classes?.contains(where: {$0.name.lowercased() == self.currentClass?.name.lowercased() && $0.selected}) ?? false ? .rBlack100 : .clear)
                            .cornerRadius(2)
                            
                            Image(systemName: "checkmark")
                            .retinaTypography(.h5_main)
                            .font(Font.title.weight(.black))
                            .foregroundColor(self.classes?.contains(where: {$0.name.lowercased() == self.currentClass?.name.lowercased() && $0.selected}) ?? false ? .rWhite : .clear)
                            
                        }
                        .padding(.leading, 24)
                            
                        
                        Text(currentClass?.name.capitalizingFirstLetter() ?? "").foregroundColor(.white).retinaTypography(.h5_main).fixedSize(horizontal: false, vertical: true).frame(width: 204, alignment: .leading).padding(.leading, 12)
                    }
                }
            }
        }
    }
}


//struct SelectionCell_Previews: PreviewProvider {
//    @State static var contacts : [Contact]? = [Contact(id: "1", name: "Alex Macdonald", phoneNum: "123", emoji: "😇", selected: false), Contact(id: "2", name: "Nick Scully", phoneNum: "123", emoji: "🤯", selected: true)]
//    static var previews: some View {
//        SelectionCell(contacts: $contacts, contact: Contact(id: "2", name: "Nick Scully", phoneNum: "123", emoji: "🤯", selected: true), isSingleSelect: false)
//    }
//}
