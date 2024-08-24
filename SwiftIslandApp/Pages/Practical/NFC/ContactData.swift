//
//  ContactData.swift
//  NFC writing Test
//
//  Created by Niels van Hoorn on 2024-08-16.
//

import Foundation
import Defaults
import Contacts

extension Defaults.Keys {
    static let contacts = Key<[TimeInterval: ContactData]>("contacts", default: [:])
}

struct ContactData: Decodable, Encodable, Hashable, Defaults.Serializable {
    var name: String = ""
    var company: String = ""
    var phone: String = ""
    var email: String = ""
    var url: String = ""
        
    var vCard: String {
        var card = """
        BEGIN:VCARD
        VERSION:3.0
        
        """
        if name != "" { card += "FN:\(name)\n" }
        if company != "" { card += "ORG:\(company)\n" }
        if phone != "" { card += "TEL:\(phone)\n" }
        if email != "" { card += "EMAIL:\(email)\n" }
        if url != "" { card += "URL:\(url)\n" }
        card += """
        END:VCARD
        """
        return card
    }
    
    var CNContact: CNMutableContact {
        // Create a new contact
        let newContact = CNMutableContact()
        newContact.givenName = name
        if (!company.isEmpty) {
            newContact.organizationName = company
        }
        if (!phone.isEmpty) {
            newContact.phoneNumbers = [CNLabeledValue(
                label: CNLabelPhoneNumberMobile,
                value: CNPhoneNumber(stringValue: phone)
            )]
        }
        if (!email.isEmpty) {
            newContact.emailAddresses = [CNLabeledValue(
                label: CNLabelWork,
                value: email as NSString
            )]
        }
        if (!url.isEmpty) {
            newContact.urlAddresses = [CNLabeledValue(
                label: CNLabelURLAddressHomePage,
                value: url as NSString
            )]
        }
        return newContact
    }
    
    var base64Encoded: String? {
        let data = try? JSONEncoder().encode(self)
        return data?.base64EncodedString()
    }
    
    init?(base64Encoded: String) {
        if let data = Data(base64Encoded: base64Encoded), let contact = try? JSONDecoder().decode(ContactData.self, from: data) {
            self = contact
            return
        }
        return nil
    }
    
    init(name: String, company: String, phone: String, email: String, url: String) {
        self.name = name
        self.company = company
        self.phone = phone
        self.email = email
        self.url = url
    }
    
    
    
    
}
