//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import Foundation

import SwiftUI
import CoreNFC
import Defaults
import ContactsUI


struct NFCPageView: View {
    @State var readerDelegate: NFCReaderDelegate = NFCReaderDelegate()
    @State private var isWriteNFCSheetPresented = false
    @State private var contactToSave: ContactData? = nil
    var isContactSheetPresented: Binding<Bool> {
        return Binding<Bool>(
            get: { contactToSave != nil },
            set: { _ in }
        )
    }
    @Default(.contacts) var contacts
    func groupedItems() -> Dictionary<DateComponents,[TimeInterval]> {
        let timestamps = contacts.keys.sorted().reversed()
        let groupedByDate = Dictionary(grouping: timestamps) { (timestamp) -> DateComponents in
            let date = Calendar.current.dateComponents([.day, .year, .month], from: (Date(timeIntervalSinceReferenceDate: timestamp)))
            return date
        }
        return groupedByDate
    }
    var body: some View {
        List {
            let groupedByDate = groupedItems()
            let items = Array<DateComponents>(groupedByDate.keys).sorted(by: {
                Calendar.current.date(from: $0) ?? Date.distantFuture >
                    Calendar.current.date(from: $1) ?? Date.distantFuture
            })
            ForEach(items, id: \.self) { (component: DateComponents) in
                if let intervals = groupedByDate[component],
                   let date = Calendar.current.date(from: component) {
                    ConnectionSection(contacts: contacts, date: date, intervals: intervals, contactToSave: $contactToSave)
                }
            }
        }
        .navigationTitle("Connections")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                Button {
                    isWriteNFCSheetPresented = true
                } label: {
                    Text("Write Your Own Tag")
                }
            }
        }
        .sheet(isPresented: $isWriteNFCSheetPresented) {
            WriteNFCView()
        }
        .sheet(isPresented: isContactSheetPresented, onDismiss: {
            contactToSave = nil
        }) {
            if let contact = contactToSave {
                NavigationStack {
                    ContactViewConroller(contact: contact.CNContact)
                        .navigationTitle("Contact")
                }
                
            }
        }
    }

    private func startNFCReading() {
        self.readerDelegate.contentCallback = { payloads in
            for payload in payloads {
                print("payload found \(payload)")
                switch payload {
                case .text(let text):
                    print("text: \(text)")
                case .url(let url):
                    print("url: \(url.absoluteString)")
                case .vcard(let content):
                    print("vCard: \(content)")
                }
            }
        }
        let nfcSession = NFCNDEFReaderSession(
            delegate: readerDelegate,
            queue: nil,
            invalidateAfterFirstRead: false
        )
        nfcSession.alertMessage = "Hold your phone against an attendee's NFC tag"
        nfcSession.begin()
    }
}


struct NFCPageView_Previews: PreviewProvider {
    static var previews: some View {
        NFCPageView()
    }
}

struct ConnectionSection: View {
    let contacts: [TimeInterval:ContactData]
    let date: Date
    let intervals: [TimeInterval]
    
    @Binding var contactToSave: ContactData?

    var body: some View {
        Section(date.formatted(date: .long, time: .omitted)) {
            ForEach(intervals, id: \.self) { interval in
                if let contact = contacts[interval] {
                    ConnectionRow(timestamp: interval, contact: contact, contactToSave: $contactToSave)
                }
            }
        }
    }
}