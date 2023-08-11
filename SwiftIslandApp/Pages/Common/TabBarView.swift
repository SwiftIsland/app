//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Defaults
import SwiftIslandDataLogic

struct TabBarView: View {
    @Namespace private var namespace
    @State private var selectedItem: Tab = .home
    @Binding var appActionTriggered: AppActions?

    @State private var isShowingMentor = false
    @EnvironmentObject private var appDataModel: AppDataModel
    @State private var maskWidth: CGFloat = 1000
    @State private var maskAlpha: CGFloat = 0
    @State private var showTicketReminder = false

    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                switch selectedItem {
                case .home:
                    ConferencePageView(namespace: namespace, isShowingMentor: $isShowingMentor)
                        .onAppear {
                            checkShowTicketReminder()
                        }
                case .practical:
                    PracticalPageView()
                case .schedule:
                    NavigationStack {
                        ScheduleView()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                TabBarBarView(selectedItem: $selectedItem)
                    .opacity(isShowingMentor ? 0 : 1)
            }

            if showTicketReminder {
                ZStack {
                    Rectangle()
                        .fill(.ultraThickMaterial)
                        .colorScheme(.dark)
                        .reverseMask {
                            Circle()
                                .frame(width: maskWidth)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                .padding(.trailing, 13)
                                .offset(CGSize(width: 0, height: 50))
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .opacity(maskAlpha)
                        .padding(0)
                        .ignoresSafeArea()

                    VStack {
                        Text("You can find your ticket here if you would like to revisit the ticket page.")
                            .foregroundColor(.white)
                            .font(.body)
                            .fontWeight(.light)
                            .padding(.top, 100)
                            .padding(.horizontal, 75)
                        Spacer()
                    }
                }
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeOut(duration: 0.5)) {
                        maskWidth = 50
                        maskAlpha = 1
                        Defaults[.hasShownTicketReminder] = true
                    }
                }
                .onTapGesture {
                    withAnimation {
                        maskAlpha = 0

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            showTicketReminder = false
                        }
                    }
                }
            }
        }.onAppear {
            handleAppAction()
        }.onChange(of: appActionTriggered) { newValue in
            handleAppAction()
        }.onChange(of: appDataModel.tickets) { newValue in
            checkShowTicketReminder()
        }
    }

    func checkShowTicketReminder() {
        if appDataModel.tickets.count > 0 && !Defaults[.hasShownTicketReminder] && selectedItem == .home {
            showTicketReminder = true
        }
    }

    func handleAppAction() {
        if let appActionTriggered {
            switch appActionTriggered {
            case .atTheConference:
                selectedItem = .practical
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
    @inlinable func reverseMask<Mask: View>(
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
