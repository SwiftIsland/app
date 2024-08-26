//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic
import UIKit
import CoreImage.CIFilterBuiltins

struct TicketsView: View {
    @Environment(\.colorScheme)
    var colorScheme

    @EnvironmentObject private var appDataModel: AppDataModel
    @State var currentTicket = Ticket.empty
    @State var answers: [Int: [Answer]] = [:]

    func accomodation(for ticket: Ticket) -> String? {
        // TODO: select the correct question, not just the first
        return answers[ticket.id]?.first?.humanizedResponse
    }

    var body: some View {
        VStack { // swiftlint:disable:this trailing_closure
            if appDataModel.tickets.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "ticket").resizable().aspectRatio(contentMode: .fit).foregroundColor(Color.questionMarkColor).frame(width: 50)
                    Text("Add tickets by pasting your ti.to/tickets URL")
                        .multilineTextAlignment(.center)
                    TicketAddButton(currentTicket: $currentTicket).padding(20)
                }
            } else {
                TabView(selection: $currentTicket) {
                    ForEach(appDataModel.tickets) { ticket in
                        VStack {
                            ZStack(alignment: .top) {
                                Image("Logo").padding(-11)
                                if ticket.editURL != nil {
                                    HStack {
                                        Spacer()
                                        NavigationLink(
                                            destination: {
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
                                                                // TODO: some error handling here, but it's pretty unlikely that the ticket suddenly does not exist
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
                            if let qrCode = ticket.qrCode {
                                Image(uiImage: qrCode)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                            }
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
            }
        }
        .onChange(of: appDataModel.tickets, { _, tickets in
            guard let currentTicket = tickets.first(where: { $0.id == self.currentTicket.id }) else { return }
            self.currentTicket = currentTicket
        })
        .task {
            answers = (try? await appDataModel.fetchAnswers(for: appDataModel.tickets)) ?? [:]
        }
        .navigationTitle("Tickets")
        .toolbar {
            if appDataModel.tickets.isEmpty {
                ToolbarItem {
                    TicketAddButton(currentTicket: $currentTicket)
                }
            }
        }
    }
}

struct TicketsView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        let appDataModel = AppDataModel()

        let ticket1 = Ticket.forPreview(firstName: "Sidney", lastName: "de Koning", releaseTitle: "Organizer Ticket")
        let ticket2 = Ticket.forPreview(firstName: "Paul", lastName: "Peelen")

        appDataModel.tickets = [ ticket1, ticket2 ]

        return NavigationStack {
            TicketsView()
                .environmentObject(appDataModel)
        }
    }
}

extension String {
    var qrImage: CIImage? {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let qrData = self.data(using: String.Encoding.ascii)
        qrFilter.setValue(qrData, forKey: "inputMessage")

        let qrTransform = CGAffineTransform(scaleX: 12, y: 12)
        return qrFilter.outputImage?.transformed(by: qrTransform)
    }
}

let context = CIContext()
let filter = CIFilter.qrCodeGenerator()

extension Ticket {
    var qrCode: UIImage? {
        filter.message = Data(slug.utf8)
        let qrTransform = CGAffineTransform(scaleX: 12, y: 12)
        guard
            let ciImage = filter.outputImage?.transformed(by: qrTransform),
            let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
        else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
