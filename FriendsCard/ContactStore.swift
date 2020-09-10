//
//  ContactStore.swift
//  FriendsCard
//
//  Created by Shalin on 9/3/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import Contacts


class ContactStore: ObservableObject {
    
    @Published var contacts: [Contact] = []
    @Published var error: Error? = nil
    
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
                        self.contacts = contactsArray
                    }
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
    }
}


extension CNContact: Identifiable {
    var name: String {
        return [givenName, familyName].filter{ $0.count > 0}.joined(separator: " ")
    }
}

