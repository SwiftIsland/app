//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct ConferencePageView: View {
    var namespace: Namespace.ID

    @EnvironmentObject private var appDataModel: AppDataModel

    @State private var selectedMentor: Mentor?
    @Binding var isShowingMentor: Bool
    @State private var mayShowMentorNextMentor: Bool = true
    @State private var ticketToShow: Ticket?
    @State private var isShowingTicketPopover = false
    @State private var showDeleteAction = false

    @Binding var storedTickets: [Ticket]


    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.defaultBackground

                ConferencePageContentView(namespace: namespace,
                                          isShowingMentor: $isShowingMentor,
                                          mayShowMentorNextMentor: $mayShowMentorNextMentor,
                                          selectedMentor: $selectedMentor)

                // The Mentor view when a mentor is selected
                if let mentor = selectedMentor, isShowingMentor {
                    MentorView(namespace: namespace, mentor: mentor, isShowContent: $isShowingMentor)
                        .matchedGeometryEffect(id: mentor.id, in: namespace)
                        .ignoresSafeArea()
                        .onDisappear {
                            mayShowMentorNextMentor = true
                        }
                }

                // The tickets button (top right) as well as the popover and the safari view
                if storedTickets.count > 0 && !isShowingMentor {
                    HStack {
                        Button {
                            if storedTickets.count == 1 {
                                ticketToShow = storedTickets.first
                            } else {
                                isShowingTicketPopover = true
                            }
                        } label: {
                            Image(systemName: "ticket")
                                .font(.body.bold())
                                .frame(width: 36, height: 36)
                                .foregroundColor(.secondary)
                                .cornerRadius(18)
                                .background(.ultraThinMaterial,
                                            in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                                .popover(isPresented: $isShowingTicketPopover,
                                         attachmentAnchor: .point(.bottom),
                                         arrowEdge: .top) {
                                    VStack(alignment: .leading) {
                                        ForEach(storedTickets) { ticket in
                                            Button {
                                                // Handled below
                                            } label: {
                                                HStack(spacing: 8) {
                                                    Image(systemName: "ticket")
                                                        .foregroundColor(.questionMarkColor)
                                                        .frame(width: 32)
                                                    VStack(alignment: .leading) {
                                                        Text(ticket.name)
                                                            .foregroundColor(.primary)
                                                            .font(.body)
                                                            .fontWeight(.light)
                                                            .dynamicTypeSize(DynamicTypeSize.small ... DynamicTypeSize.medium)
                                                        Text("Added \(ticket.addDate.relativeDateDisplay())")
                                                            .foregroundColor(.secondary)
                                                            .font(.footnote)
                                                            .dynamicTypeSize(DynamicTypeSize.small ... DynamicTypeSize.medium)
                                                    }
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                        .foregroundColor(.secondary)
                                                        .font(.footnote)
                                                }
                                                .padding(.vertical, 3)
                                                .onTapGesture {
                                                    isShowingTicketPopover = false
                                                    ticketToShow = ticket
                                                }
                                            }
                                        }
                                        HStack(spacing: 8) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                                .frame(width: 32)
                                            VStack(alignment: .leading) {
                                                Text("Remove tickets")
                                                    .foregroundColor(.red)
                                                    .font(.body)
                                                    .fontWeight(.light)
                                                    .dynamicTypeSize(DynamicTypeSize.small ... DynamicTypeSize.medium)
                                            }
                                        }
                                        .padding(.vertical, 3)
                                        .onTapGesture {
                                            showDeleteAction = true
                                        }
                                        .confirmationDialog("Which ticket would you like to delete from the app?", isPresented: $showDeleteAction, titleVisibility: .visible) {
                                            ForEach(storedTickets) { ticket in
                                                Button("Delete \(ticket.name)", role: .destructive) {
                                                    showDeleteAction = false
                                                    let filteredStoredTickets = storedTickets.filter { $0.id != ticket.id }
                                                    if !isPreview {
                                                        try? KeychainManager.shared.store(key: .tickets, data: filteredStoredTickets)
                                                    }
                                                    self.storedTickets = filteredStoredTickets
                                                }
                                            }
                                        }
                                    }
                                    .foregroundColor(.primary)
                                    .padding()
                                    .presentationCompactAdaptation(.popover)
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.trailing, 20)
                }
            }
            .navigationDestination(for: [FAQItem].self) { _ in
                FAQListView()
            }
            .navigationDestination(for: FAQItem.self) { item in
                FAQListView(preselectedItem: item)
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: UIDevice.current.hasNotch ? 88 : 66)
            }
        }
        .accentColor(.white)
        .sheet(item: $ticketToShow, content: { ticket in
            if let url = URL(string: "https://ti.to/swiftisland/2023/tickets/\(ticket.id)") {
                SafariWebView(url: url)
            } else {
                Text("The ticket ID provided was invalid")
            }
        })
    }
}

struct ConferencePageView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        let event = Event.forPreview()

        let appDataModel = AppDataModel()
        appDataModel.events = [event]

        let tickets = [
            Ticket(id: "1", addDate: Date(timeIntervalSinceNow: -308), name: "Ticket 1"),
            Ticket(id: "2", addDate: Date(timeIntervalSinceNow: -(11 * 60)), name: "Ticket 2"),
            Ticket(id: "3", addDate: Date(timeIntervalSinceNow: -((24 * 3) * 60)), name: "Ticket 3")
        ]

        return ConferencePageView(namespace: namespace, isShowingMentor: .constant(false), storedTickets: .constant(tickets))
            .environmentObject(appDataModel)
    }
}
