//
//  Payload.swift
//  NFC writing Test
//
//  Created by Niels van Hoorn on 2024-08-16.
//

import Foundation
import CoreNFC

enum Payload {
    case url(URL)
    case text(String)
    case vcard(String)
    
    init?(ndef: NFCNDEFPayload) {
        if let url = ndef.wellKnownTypeURIPayload() {
            self = .url(url)
            return
        }
        let (text,_) = ndef.wellKnownTypeTextPayload()
        if let text = text {
            self = .text(text)
            return
        }
        if ndef.typeNameFormat == .media, 
            String(data: ndef.type, encoding: .utf8) == "text/vcard",
            let content = String(data: ndef.payload, encoding: .utf8) {
            self = .vcard(content)
            return
        }
        return nil
    }
    
    var ndef: NFCNDEFPayload? {
        switch (self) {
        case .text(let text): return NFCNDEFPayload.wellKnownTypeTextPayload(string: text, locale: .current)
        case .url(let url): return NFCNDEFPayload.wellKnownTypeURIPayload(url: url)
        case .vcard(let content):
            return NFCNDEFPayload(format: .media, type: "text/vcard".data(using: .utf8)!, identifier: Data(), payload: content.data(using: .utf8)!)
        }
    }
}
