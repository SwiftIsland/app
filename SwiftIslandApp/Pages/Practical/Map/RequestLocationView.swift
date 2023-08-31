//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import CoreLocation

enum RequestLocationAction {
    case shareLocation
    case openSettings
    case canceled
}

struct RequestLocationView: View {
    @Environment(\.dismiss)
    var dismiss

    let locationManager = CLLocationManager()

    @State private var authorizationStatus: CLAuthorizationStatus?

    let selectedAction: (RequestLocationAction) -> Void

    var body: some View {
        ZStack {
            LinearGradient.defaultBackground

            VStack(alignment: .center, spacing: 10) {
                Image(systemName: "location")
                    .foregroundColor(.questionMarkColor)
                    .font(.system(size: 42))
                    .fontWeight(.light)
                    .dynamicTypeSize(.medium)
                Text("Location permission")
                    .font(.title)
                    .fontWeight(.light)
                Text("We need your location permission in order to verify that you are at the conference.\n\nWe do not store your location and once you are confirmed to be at the conference, we will not further use your location information.") // swiftlint:disable:this line_length
                    .multilineTextAlignment(.center)
                if case .denied = authorizationStatus {
                    Text("Unfortunately you have denied this app to access your location. If you wish to give this app access, you need to change the settings.")

                    Button("Open settings") {
                        selectedAction(.openSettings)
                    }
                    .buttonStyle(SwiftIslandButtonStyle())
                    .padding(.top, 25)
                    .padding(.bottom, 5)
                } else {
                    Button("Share location") {
                        selectedAction(.shareLocation)
                    }
                    .buttonStyle(SwiftIslandButtonStyle())
                    .padding(.top, 25)
                    .padding(.bottom, 5)
                }

                Button("Cancel") {
                    selectedAction(.canceled)
                }
                .foregroundColor(.primary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .dynamicTypeSize(DynamicTypeSize.small...DynamicTypeSize.xLarge)
        }
        .onAppear {
            authorizationStatus = locationManager.authorizationStatus
        }
        .interactiveDismissDisabled()
    }
}

struct RequestLocationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RequestLocationView { _ in }
                .preferredColorScheme(.light)
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Light")
            RequestLocationView { _ in }
                .environment(\.sizeCategory, .extraExtraExtraLarge)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark")
        }
    }
}
