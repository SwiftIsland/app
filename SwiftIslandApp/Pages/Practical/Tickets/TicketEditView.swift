//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct TicketEditView: View {
    @EnvironmentObject private var appDataModel: AppDataModel
    @State var ticket: Ticket
    @State private var showDeleteConfirmation = false
    var body: some View {
        // Not nice, but shouldn't show this view for tickets without editURL
        ZStack {
            if let editUrl = ticket.editURL {
                WebView(url: editUrl)
                    .navigationTitle("Edit")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(Color.black, for: .navigationBar)
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbar {
                        ToolbarItem {
                            Button {
                                showDeleteConfirmation = true
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                    .confirmationDialog("Are you sure you want to\n delete this ticket from the app?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                        Button("Delete", role: .destructive) {
                            showDeleteConfirmation = false
                            try? appDataModel.removeTicket(ticket: ticket)
                        }
                    }
            } else {
                Text("No edit URL was found for the ticket.")
            }
        }
    }
}

struct TicketEditView_Previews: PreviewProvider {
    static var previews: some View {
        let appDataModel = AppDataModel()
        let ticket = Ticket.forPreview(firstName: "Paul", lastName: "Peelen")

        NavigationStack {
            TicketEditView(ticket: ticket)
        }.environmentObject(appDataModel)
    }
}
