//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct TicketAddButton: View {
    @EnvironmentObject private var appDataModel: AppDataModel
    @Binding var currentTicket: Ticket
    @State var failedPasteAlert: String?
    @State var presentFailedPasteAlert = false

    func addTicketFromPasteBoard(text: String?) {
        guard let text = text else {
            presentFailedPasteAlert = true
            failedPasteAlert = "Nothing on the clipboard, or no clipboard access"
            return
        }
        guard let url = URL(string: text) else {
            presentFailedPasteAlert = true
            failedPasteAlert = "Please copy an URL\n\n\(text)"
            return
        }
        guard url.host == "ti.to" else {
            presentFailedPasteAlert = true
            failedPasteAlert = "Please copy a ti.to URL\n\n\(url.absoluteString)"
            return
        }
        var path = url.pathComponents
        if (path.last == "settings") {
            let _ = path.popLast()
        }
        let slug = path.popLast()
        guard let slug = slug, path.last == "tickets" else {
            presentFailedPasteAlert = true
            failedPasteAlert = "Please copy a ti.to/tickets URL\n\n\(url.absoluteString)"
            return
        }
        Task {
            do {
                if let ticket = try await appDataModel.updateTicket(slug: slug) {
                    currentTicket = ticket
                }
            } catch DataLogicError.requestError(message: let message) {
                presentFailedPasteAlert = true
                failedPasteAlert = "Failed to find ticket\n\n\(message)"
            } catch {
                presentFailedPasteAlert = true
                failedPasteAlert = "Failed to find ticket\n\n\(error)"
            }
        }
    }
    var body: some View {
        PasteButton(payloadType: String.self) { strings in
            addTicketFromPasteBoard(text: strings.first)
        }
        .alert("Failed to paste ticket URL", isPresented: $presentFailedPasteAlert) {
            Button("OK") {
                presentFailedPasteAlert = false
                failedPasteAlert = nil
            }
        } message: {
            Text(failedPasteAlert ?? "")
        }
    }
}

struct TicketAddButton_Previews: PreviewProvider {
    @State static var ticket = Ticket.forPreview()
    static var previews: some View {
        TicketAddButton(currentTicket: $ticket)
    }
}
