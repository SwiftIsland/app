//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ConnectionRow: View {
    var timestamp: TimeInterval
    var contact: ContactData
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(contact.name).font(.custom("WorkSans-Bold", size: 24))
                Text(contact.company).font(.custom("WorkSans-Regular", size: 18))
            }
            Spacer()
            Text(Date(timeIntervalSinceReferenceDate: timestamp).formatted(date: .omitted, time: .shortened)).font(.custom("WorkSans-Regular", size: 18))
        }.padding(20)
    }
}

#Preview {
    let time = Date().timeIntervalSinceReferenceDate
    let contact = ContactData(name: "Niels van Hoorn", company: "Framer", address: "", phone: "", email: "", url: "")
    return ConnectionRow(timestamp: time, contact: contact)
}
