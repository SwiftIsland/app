//
//  ContactData.swift
//  NFC writing Test
//
//  Created by Niels van Hoorn on 2024-08-16.
//

import Foundation

struct ContactData: Decodable, Encodable {
    var name: String = ""
    var company: String = ""
    var address: String = ""
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
    
    var base64Encoded: String? {
        let data = try? JSONEncoder().encode(self)
        return data?.base64EncodedString()
    }
    
    init(base64Encoded: String) {
        if let data = Data(base64Encoded: base64Encoded), let contact = try? JSONDecoder().decode(ContactData.self, from: data) {
            self = contact
            return
        }
    }
    
    init(name: String, company: String, address: String, phone: String, email: String, url: String) {
        self.name = name
        self.company = company
        self.address = address
        self.phone = phone
        self.email = email
        self.url = url
    }
    
    
    
    
}
