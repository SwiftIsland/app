//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Defaults
import SwiftIslandDataLogic

private enum Tabs: CaseIterable {
    case home
    case practical
    case schedule
}

struct TabBarView: View {
    @Namespace private var namespace
    @State private var selectedItem: Tabs = .home
    @Binding var appActionTriggered: AppActions?

    @State private var isShowingMentor = false
    @EnvironmentObject private var appDataModel: AppDataModel

    @Default(.userIsActivated)
    private var userIsActivated

    var body: some View {
        ZStack {
            TabView(selection: $selectedItem) {
                Tab("Conference", systemImage: "person.3", value: .home) {
                    ConferencePageView(namespace: namespace, isShowingMentor: $isShowingMentor)
                }
                Tab("Practical", systemImage: "wallet.pass", value: .practical) {
                    PracticalPageView()
                }
                Tab("Schedule", systemImage: "calendar", value: .schedule) {
                    NavigationStack {
                        ScheduleView()
                    }
                }
            }
            .accentColor(.questionMarkColor)
        }
        .onAppear {
            handleAppAction()
        }
        .onChange(of: appActionTriggered) { _, _ in
            handleAppAction()
        }
        .onChange(of: appDataModel.tickets) { _, _ in
            // TODO: Open the ticket page
        }
    }


    func handleAppAction() {
        if let appActionTriggered {
            switch appActionTriggered {
            case .atTheConference:
                selectedItem = .practical
            case .atHome:
                selectedItem = .home
            }

            self.appActionTriggered = nil
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabBarView(appActionTriggered: .constant(nil))
                .previewDisplayName("Light mode")
            TabBarView(appActionTriggered: .constant(nil))
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}


extension View {
    @inlinable
    func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask(
            ZStack {
                Rectangle()

                mask()
                    .blendMode(.destinationOut)
            }
        )
    }
}

extension Mentor: @retroactive Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .content)
    }
}
