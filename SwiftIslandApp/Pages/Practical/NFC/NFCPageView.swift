//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import Foundation

import SwiftUI
import CoreNFC


struct NFCPageView: View {
    @State var readerDelegate: NFCReaderDelegate = NFCReaderDelegate()
    @State private var isWriteNFCSheetPresented = false
    var body: some View {
        VStack {
            Text("TBD")
        }
        .navigationTitle("Connections")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                Button {
                    isWriteNFCSheetPresented = true
                } label: {
                    Text("Your Tag")
                }
            }
        }
        .sheet(isPresented: $isWriteNFCSheetPresented) {
            WriteNFCView()
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
