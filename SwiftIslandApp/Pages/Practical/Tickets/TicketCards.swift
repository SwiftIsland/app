//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct TicketCards: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var appDataModel: AppDataModel
    @Binding var currentTicket: Ticket
    @Binding var failedPasteAlert: String?
    @Binding var presentFailedPasteAlert: Bool
    @State var answers: [Int:[Answer]]? = nil
    
    
    func updateAnswers() async {
        print("updating answers")
        answers = (try? await appDataModel.fetchAnswers(for: appDataModel.tickets)) ?? [:]
        print("updated answers")
    }
    
    func accomodation(for ticket: Ticket) -> String? {
        // TODO: select the correct question, not just the first
        return answers?[ticket.id]?.first?.humanizedResponse
    }
    
    var body: some View {
        TabView(selection: $currentTicket) {
            ForEach(appDataModel.tickets) { ticket in
                VStack {
                    ZStack(alignment: .top) {
                        Image("Logo").padding(-11)
                        if ticket.editURL != nil {
                            HStack {
                                Spacer()
                                NavigationLink(destination: {
                                    TicketEditView(ticket: ticket)
                                    .safeAreaInset(edge: .bottom) {
                                        Color.clear.frame(height: UIDevice.current.hasNotch ? 46 : 58)
                                    }
                                    .onDisappear {
                                        Task {
                                            do {
                                                if let ticket = try await appDataModel.updateTicket(slug: ticket.slug, add: false) {
                                                    currentTicket = ticket
                                                }
                                            } catch {
                                                presentFailedPasteAlert = true
                                                failedPasteAlert = "Failed to find ticket\n\n\(error)"
                                            }
                                        }
                                    }
                                }, label: {
                                    Image(systemName: "pencil.circle")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.questionMarkColor)
                                })
                            }
                        }
                    }
                    VStack(alignment: .leading) {
                        Text(ticket.name)
                            .foregroundColor(.primary)
                            .font(.largeTitle)
                        HStack {
                            Image(systemName: ticket.icon)
                            Text(ticket.title)
                        }.foregroundColor(.secondary)
                            .font(.title2)
                        let accomodation = accomodation(for: ticket)
                        HStack {
                            Image(systemName: "bed.double.fill")
                            Text(accomodation ?? "TBD")
                        }
                        .foregroundColor(.secondary)
                        .font(.title3)
                        .opacity(accomodation == nil ? 0 : 1)

                    }
                    Image(uiImage: ticket.qrCode!).resizable().scaledToFit()
                        .frame(width: 200, height: 200)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(.ultraThickMaterial)
                .cornerRadius(20)
                .padding(20)
                .tag(ticket)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .indexViewStyle(.page(backgroundDisplayMode: colorScheme == .light ? .always : .automatic))
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: UIDevice.current.hasNotch ? 88 : 66)
        }
        .task {
            answers = (try? await appDataModel.fetchAnswers(for: appDataModel.tickets)) ?? [:]
        }
    }
}

struct TicketCards_Previews: PreviewProvider {
    @State static var currentTicket = Ticket.forPreview()
    @State static var presentAlert = false
    @State static var alert: String? = "Ttst"
    static var previews: some View {
        TicketCards(currentTicket: $currentTicket, failedPasteAlert: $alert, presentFailedPasteAlert: $presentAlert)
    }
}
