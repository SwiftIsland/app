//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Defaults

private enum ActionStatus {
    case idle
    case checking
    case failed
    case completed
}

struct SectionAtTheConferenceNotActivated: View {
    let iconMaxWidth: CGFloat

    @State private var isShowingLocationPermissionView = false
    @State private var actionStatus: ActionStatus = .idle
    @State private var showingAlert = false

    @Default(.userIsActivated)
    private var userIsActivated

    private let hasNFC = NFCManager.deviceHasNFCSupport()
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        Section(header: Text("At the conference")) {
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    Image(systemName: "qrcode.viewfinder")
                        .foregroundColor(.questionMarkColor)
                        .padding()
                        .font(.title)
                    Spacer()
                    if hasNFC {
                        Image(systemName: "wave.3.forward")
                            .foregroundColor(.questionMarkColor)
                            .padding()
                            .font(.title)
                        Spacer()
                    }
                    Image(systemName: "map.fill")
                        .foregroundColor(.questionMarkColor)
                        .padding()
                        .font(.title)
                    Spacer()
                }
                if hasNFC {
                    Text("Use your location or scan the **NFC tag** or **QR code** at the reception to confirm you have arrived.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                } else {
                    Text("Use your location or scan the **QR code** at the reception to confirm you have arrived.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                }
            }
            .sheet(isPresented: $isShowingLocationPermissionView) {
                RequestLocationView { action in
                    isShowingLocationPermissionView.toggle()
                    switch action {
                    case .canceled:
                        actionStatus = .failed
                    case .shareLocation:
                        getAuthorization()
                    case .openSettings:
                        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(url)
                    }
                }
                .presentationDetents([.medium])
            }
            Button {
                guard case .idle = actionStatus else { return }
                actionStatus = .checking

                if locationManager.currentAuthorizationStatus == .notDetermined
                    || locationManager.currentAuthorizationStatus == .denied {
                    isShowingLocationPermissionView = true
                } else {
                    getLocation()
                }
            } label: {
                HStack {
                    Image(systemName: "location")
                        .foregroundColor(.questionMarkColor)
                        .frame(maxWidth: iconMaxWidth)
                    Text("Am I there yet?")
                        .font(.body)
                        .dynamicTypeSize(.small ... .medium)
                        .foregroundColor(.primary)
                    Spacer()
                    switch actionStatus {
                    case .idle:
                        Image(systemName: "chevron.right")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    case .checking:
                        ProgressView()
                    case .failed:
                        Image(systemName: "xmark")
                            .foregroundColor(.secondary)
                            .onAppear {
                                resetActionStatus()
                            }
                    case .completed:
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                            .onAppear {
                                resetActionStatus()
                            }
                    }
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text(userIsActivated ? "👋🏻" : "😢"),
                message: Text(userIsActivated ?
                    "Welcome! Glad to see you have arrived!\n\nPlease make sure to check-in if you haven't already.\nThere are now a few new options available on this page." :
                    "Unfortunately it doesn't look like you are on the island just yet.\n\nPlease give it a go later or try the QR code \(hasNFC ? "or NFC tag " : "")at the reception."),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }
}

private extension SectionAtTheConferenceNotActivated {
    func resetActionStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation {
                actionStatus = .idle
            }
        }
    }

    func getAuthorization() {
        Task {
            let authorization = await locationManager.requestAuthorization()

            switch authorization {
            case .notDetermined, .restricted, .denied:
                actionStatus = .failed
            case .authorizedAlways, .authorizedWhenInUse, .authorized:
                getLocation()
            default:
                actionStatus = .failed
            }
        }
    }

    func getLocation() {
        Task {
            do {
                guard let location = try await locationManager.requestLocation() else {
                    actionStatus = .failed
                    return
                }

                // Do something with the location
                if locationManager.isCoordinateInTexel(location) {
                    withAnimation {
                        userIsActivated = true
                    }
                }

                actionStatus = .completed
                showingAlert = true
            } catch {
                actionStatus = .failed
            }
        }
    }
}

struct SectionAtTheConferenceNotActivated_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SectionAtTheConferenceNotActivated(iconMaxWidth: 32)
        }
    }
}
