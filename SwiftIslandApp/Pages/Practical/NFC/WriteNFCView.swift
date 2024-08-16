//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import SwiftUI
import CoreNFC

struct WriteNFCView: View {
    let writerDelegate: NFCWriterDelegate = NFCWriterDelegate()
    @State private var contact: ContactData = ContactData(name: "Niels", company: "Framer", address: "Test", phone: "", email: "niels@swiftisland.nl", url: "https://swiftisland.nl")

    var body: some View {
        NavigationStack {
            VStack {
                if (NFCReaderSession.readingAvailable) {
                    Text("Input your details below to write this data to your NFC Tag")
                    ContactLine(label: "Name", placeholder: "Taylor Swift", value: $contact.name)
                    ContactLine(label: "Company", placeholder: "Swift Island", value: $contact.company)
                    ContactLine(label: "Phone", placeholder: "+31612345678", value: $contact.phone)
                    ContactLine(label: "Email", placeholder: "taylor@swiftisland.nl", value: $contact.email)
                    ContactLine(label: "URL", placeholder: "https://swiftisland.nl", value: $contact.url)
                    Button("Write NFC Tag") {
                        writeNFCTag()
                    }
                    .padding()
                } else {
                    Text("Your device does not support NFC unfortunately")
                }
            }
            .padding(20)
            .navigationTitle("Write Your Own Tag")
        }
    }
    
    private func writeNFCTag() {
        var content: [Payload] = []
        content.append(.vcard(contact.vCard))
        var url = URL(string: "https://swiftisland.nl/app")!
        let queryItem = URLQueryItem(name: "contact", value: contact.base64Encoded)
        url.append(queryItems: [queryItem])
        content.append(.url(url))
        writerDelegate.content = content
        let nfcSession = NFCNDEFReaderSession(
            delegate: writerDelegate,
            queue: nil,
            invalidateAfterFirstRead: false
        )
        nfcSession.alertMessage = "Hold your phone against your NFC tag to write it."
        nfcSession.begin()
    }

}

struct ContactLine: View {
    let label: String
    let placeholder: String
    @Binding var value: String
    var body: some View {
        HStack {
            Text(label).frame(width: 80, alignment: .trailing).padding(5)
            TextField(placeholder, text: $value).padding(5).border(.secondary)
        }
    }
    
}


#Preview {
    WriteNFCView()
}
