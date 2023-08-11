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
    @State var currentId: Int?
    var body: some View {
        List {
            ForEach(appDataModel.tickets) { ticket in
                let isActive = currentId == ticket.id
                Section {
                    VStack {
                        HStack {
                            Image(systemName: "ticket")
                                .foregroundColor(.questionMarkColor)
                                .frame(width: 32)
                            VStack(alignment: .leading) {
                                Text(ticket.name)
                                    .foregroundColor(.primary)
                                    .font(.body)
                                    .fontWeight(.light)
                                    .dynamicTypeSize(DynamicTypeSize.small ... DynamicTypeSize.medium)
                                Text(ticket.title)
                                    .foregroundColor(.secondary)
                                    .font(.footnote)
                                    .dynamicTypeSize(DynamicTypeSize.small ... DynamicTypeSize.medium)
                            }
                            Spacer()
                            Image(systemName: isActive ? "chevron.down" : "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.footnote)
                        }
                        if isActive {
                            Image(uiImage: ticket.qrCode!).resizable().scaledToFit().frame(width: 200, height: 200)
                        }
                    }
                }.onTapGesture {
                    currentId = isActive ? nil : ticket.id
                }
                
            }
            .padding(.vertical, 10)
            
        }
    .navigationTitle("Tickets")
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

extension StringProtocol {
    var qrCode: UIImage? {
        guard
            let data = data(using: .isoLatin1),
            let outputImage = CIFilter(name: "CIQRCodeGenerator",
                              parameters: ["inputMessage": data, "inputCorrectionLevel": "M"])?.outputImage
        else { return nil }
        let size = outputImage.extent.integral
        let output = CGSize(width: 250, height: 250)
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        return UIGraphicsImageRenderer(size: output, format: format).image { _ in outputImage
            .transformed(by: .init(scaleX: output.width/size.width, y: output.height/size.height))
            .image
            .draw(in: .init(origin: .zero, size: output))
        }
    }
}
extension CIImage {
    var image: UIImage { .init(ciImage: self) }
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
