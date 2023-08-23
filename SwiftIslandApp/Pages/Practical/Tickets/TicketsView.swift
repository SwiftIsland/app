//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct TicketsView: View {
    @EnvironmentObject private var appDataModel: AppDataModel
    @State var currentTicket: Ticket = Ticket.empty
    @State var answers: [Int:[Answer]] = [:]
    @State var failedPasteAlert: String? = nil
    @State var presentFailedPasteAlert: Bool = false
    
    func accomodation(for ticket: Ticket) -> String? {
        // TODO: select the correct question, not just the first
        return answers[ticket.id]?.first?.humanizedResponse
    }
    func addTicketFromPasteBoard() {
        guard let text = UIPasteboard.general.string else {
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
            } catch {
                presentFailedPasteAlert = true
                failedPasteAlert = "Failed to find ticket\n\n\(error)"
            }
        }
    }
    var body: some View {
        VStack {
            if (appDataModel.tickets.count == 0 ) {
                ZStack {
                    Color.black
                    Text("Add tickets by pasting your ti.to/tickets URL")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
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
                .foregroundColor(.white)
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: UIDevice.current.hasNotch ? 88 : 66)
                }
            }
        }
        .background(.black)
        .task {
            answers = (try? await appDataModel.fetchAnswers(for: appDataModel.tickets)) ?? [:]
        }
        .navigationTitle("Tickets")
        .toolbarBackground(
            Color.black,
            for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem() {
                Button {
                    addTicketFromPasteBoard()
                } label: {
                    Text("Paste URL")
                }
                
            }
        }.alert("Failed to paste ticket URL", isPresented: $presentFailedPasteAlert) {
            Button("OK") {
                presentFailedPasteAlert = false
                failedPasteAlert = nil
            }
        } message: {
            Text(failedPasteAlert ?? "")
        }

    }
}

struct TicketsView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        let appDataModel = AppDataModel()

        let ticket1 = Ticket.forPreview(firstName: "Sidney" , lastName: "de Koning", releaseTitle: "Organizer Ticket")
        let ticket2 = Ticket.forPreview(firstName: "Paul" , lastName: "Peelen")

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
        guard let ciImage = filter.outputImage?.transformed(by: qrTransform),
      let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
        else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
