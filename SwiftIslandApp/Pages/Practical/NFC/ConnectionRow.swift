//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import SwiftUI
import Defaults

struct ConnectionRow: View {
    var timestamp: TimeInterval
    var contact: ContactData
    @Binding var contactToSave: ContactData?
    @State private var showingDeleteConfirmation = false
    @State var expanded: Bool = false
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(contact.name).font(.custom("WorkSans-Bold", size: 24))
                if (!contact.company.isEmpty) {
                    Text(contact.company).font(.custom("WorkSans-Regular", size: 18))
                }
                if (expanded) {
                    if (!contact.phone.isEmpty) {
                        Text(contact.phone).font(.custom("WorkSans-Regular", size: 14))
                    }
                    if (!contact.email.isEmpty) {
                        Text(contact.email).font(.custom("WorkSans-Regular", size: 14))
                    }
                    if (!contact.url.isEmpty) {
                        if let url = URL(string: contact.url) {
                            Link(contact.url, destination: url).font(.custom("WorkSans-Regular", size: 14))
                        } else {
                            Text(contact.url).font(.custom("WorkSans-Regular", size: 14))
                        }
                    }
                }
            }
            Spacer()
            Text(Date(timeIntervalSinceReferenceDate: timestamp).formatted(date: .omitted, time: .shortened)).font(.custom("WorkSans-Regular", size: 18))
        }.onTapGesture {
            withAnimation {
                expanded = !expanded
            }
        }.swipeActions {
            Button(action: {
                showingDeleteConfirmation = true
            }) {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
            Button(action: {
                contactToSave = contact
            }) {
                Label("Add Contact", systemImage: "person.crop.circle.badge.plus")
            }
            .tint(.green)

        }.confirmationDialog("Are you sure you want to delete this item?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                Defaults[.contacts].removeValue(forKey: timestamp)
            }
            Button("Cancel", role: .cancel) {
                showingDeleteConfirmation = false
            }
        }
    }
}

#Preview {
    let time = Date().timeIntervalSinceReferenceDate
    let contact = ContactData(name: "Niels van Hoorn", company: "Framer", phone: "", email: "", url: "")
    let contactToSave = Binding<ContactData?> {
        nil
    } set: { _ in
    }
    return ConnectionRow(timestamp: time, contact: contact, contactToSave: contactToSave)
}
