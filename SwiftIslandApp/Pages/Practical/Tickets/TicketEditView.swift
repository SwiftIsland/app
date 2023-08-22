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
        // Not nice, but shouldnt show this view for tickets without editURL
        WebView(url: ticket.editURL!)
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem() {
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
            
        
    }
}

struct TicketEditView_Previews: PreviewProvider {
    static var previews: some View {
        let appDataModel = AppDataModel()
        let ticket1 = """
        {"id":9973611,"slug":"ti_pVxPdTDrCZE92Fr4PMiZEdA","first_name":"Paul","last_name":"Peelen","release_title":"Conference Ticket","reference":"RD2J-1","registration_reference":"RD2J","tags":null,"created_at":"2023-07-07T07:28:34.000Z","updated_at":"2023-07-07T07:32:17.000Z"}
        """
        
        let ticket = try! Ticket(from: ticket1.data(using: .utf8)!)
        NavigationStack {
            TicketEditView(ticket: ticket)
        }.environmentObject(appDataModel)
    }
}
