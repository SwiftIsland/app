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
    @State var answers: [Ticket:[Answer]] = [:]
    @State var failedPasteAlert: String? = nil
    @State var presentFailedPasteAlert: Bool = false
    
    func accomodation(for ticket: Ticket) -> String? {
        // TODO: select the correct question, not just the first
        return answers[ticket]?.first?.humanizedResponse
    }
    func addTicketFromPasteBoard() {
        if let text = UIPasteboard.general.string {
            if let url = URL(string: text) {
                if url.host == "ti.to" {
                    var path = url.pathComponents
                    let slug = path.popLast()
                    if let slug = slug, path.last == "tickets" {
                        Task {
                            do {
                                currentTicket = try await appDataModel.addTicket(slug: slug)
                            } catch {
                                presentFailedPasteAlert = true
                                failedPasteAlert = "Failed to find ticket\n\n\(error)"
                            }
                        }
                    } else {
                        presentFailedPasteAlert = true
                        failedPasteAlert = "Please copy a ti.to ticket URL\n\n\(url.absoluteString)"
                    }
                } else {
                    presentFailedPasteAlert = true
                    failedPasteAlert = "Please copy a ti.to URL\n\n\(url.absoluteString)"
                }
            } else {
                presentFailedPasteAlert = true
                failedPasteAlert = "Please copy an URL\n\n\(text)"
            }
        } else {
            presentFailedPasteAlert = true
            failedPasteAlert = "Nothing on the clipboard, or no clipboard access"
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
                            HStack(alignment: .top) {
                                Spacer()
                                Spacer()
                                Image("Logo").padding(-10)
                                Spacer()
                                if ticket.editURL != nil {
                                    NavigationLink(destination: {
                                        TicketEditView(ticket: ticket)
                                    }, label: {
                                        Image(systemName: "pencil.circle")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(.questionMarkColor)
                                    })
                                } else {
                                    Spacer()
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
                .tabViewStyle(.page(indexDisplayMode: .always))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
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
        
        let ticket1 = """
        {"id":9973691,"slug":"ti_pVxPdTDrCZE92Fr4PMiZEdA","first_name":"Sidney","last_name":"de Koning","release_title":"Organizer Ticket","reference":"RD2J-1","registration_reference":"RD2J","tags":null,"created_at":"2023-07-07T07:28:34.000Z","updated_at":"2023-07-07T07:32:17.000Z"}
        """
        let ticket2 = """
        {"id":9973611,"slug":"ti_pVxPdTDrCZE92Fr4PMiZEdA","first_name":"Paul","last_name":"Peelen","release_title":"Conference Ticket","reference":"RD2J-1","registration_reference":"RD2J","tags":null,"created_at":"2023-07-07T07:28:34.000Z","updated_at":"2023-07-07T07:32:17.000Z"}
        """
        appDataModel.tickets = [
            try! Ticket(from: ticket1.data(using: .utf8)!),
            try! Ticket(from: ticket2.data(using: .utf8)!)
        ]

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
