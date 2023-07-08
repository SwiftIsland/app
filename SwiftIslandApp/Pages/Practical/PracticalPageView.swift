//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct PracticalPageView: View {
    private let iconMaxWidth: CGFloat = 32

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.conferenceBackgroundFrom, .conferenceBackgroundTo], startPoint: UnitPoint(x: 0, y: 0.1), endPoint: UnitPoint(x: 1, y: 1))
                    .ignoresSafeArea()

                List {
                    Section(header: Text("Before you leave")) {
                        HStack {
                            Text("Make sure you are all set for a few days of awesome workshops.")
                                .font(.subheadline)
                        }
                        NavigationLink(destination: {
                            Text("Packlist")
                        }, label: {
                            HStack {
                                Image(systemName: "suitcase.rolling")
                                    .foregroundColor(.questionMarkColor)
                                    .frame(maxWidth: iconMaxWidth)
                                Text("Packlist")
                                    .dynamicTypeSize(.small ... .medium)
                            }
                        })
                    }

                    Section(header: Text("Getting here")) {
                        HStack {
                            Text("Make sure you get here the right way!\nIn order to do so, we've put together some guides to make it a little easier for you.")
                                .font(.subheadline)
                        }
                        NavigationLink(destination: {
                            Text("Hassle Free Ticket")
                        }, label: {
                            HStack {
                                Image(systemName: "ticket")
                                    .foregroundColor(.questionMarkColor)
                                    .frame(maxWidth: iconMaxWidth)
                                Text("Hassle Free Ticket")
                                    .dynamicTypeSize(.small ... .medium)
                            }
                        })
                        NavigationLink(destination: {
                            Text("Schiphol")
                        }, label: {
                            HStack {
                                Image(systemName: "airplane.arrival")
                                    .foregroundColor(.questionMarkColor)
                                    .frame(maxWidth: iconMaxWidth)
                                Text("At Schiphol")
                                    .dynamicTypeSize(.small ... .medium)
                            }
                        })

                        NavigationLink(destination: {
                            Text("Directions")
                        }, label: {
                            HStack {
                                Image(systemName: "bicycle")
                                    .foregroundColor(.questionMarkColor)
                                    .frame(maxWidth: iconMaxWidth)
                                Text("Directions")
                                    .dynamicTypeSize(.small ... .medium)
                            }
                        })
                        NavigationLink(destination: {
                            Text("On location")
                        }, label: {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.questionMarkColor)
                                    .frame(maxWidth: iconMaxWidth)
                                Text("On Location")
                                    .dynamicTypeSize(.small ... .medium)
                            }
                        })
                    }

                    Section(header: Text("At the conference (too far away)")) {
                        VStack(alignment: .center) {
                            Image(systemName: "sailboat")
                                .foregroundColor(.questionMarkColor)
                                .padding()
                                .font(.title)
                            Text("Once you are at the conference, you'll find more information here. So, make your way here and when you are close enough, we'll update this list for you!")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                        }
                    }

                    Section(header: Text("At the conference (User is here)")) {
                        HStack {
                            Text("You made it! We are very happy too see you made it to the conference!")
                                .font(.subheadline)
                        }
                        NavigationLink(destination: {
                            Text("Schedule")
                        }, label: {
                            HStack {
                                Image(systemName: "calendar.day.timeline.leading")
                                    .foregroundColor(.questionMarkColor)
                                    .frame(maxWidth: iconMaxWidth)
                                Text("Checkout the schedule")
                                    .dynamicTypeSize(.small ... .medium)
                            }
                        })
                        NavigationLink(destination: {
                            Text("Map")
                        }, label: {
                            HStack {
                                Image(systemName: "map")
                                    .foregroundColor(.questionMarkColor)
                                    .frame(maxWidth: iconMaxWidth)
                                Text("Map")
                                    .dynamicTypeSize(.small ... .medium)
                            }
                        })
                        NavigationLink(destination: {
                            Text("Slack")
                        }, label: {
                            HStack {
                                Image(systemName: "message")
                                    .foregroundColor(.questionMarkColor)
                                    .frame(maxWidth: iconMaxWidth)
                                Text("Join our Slack")
                                    .dynamicTypeSize(.small ... .medium)
                            }
                        })
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Practical")
        }
    }
}

struct PracticalPageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PracticalPageView()
                .previewDisplayName("Light mode")
            PracticalPageView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}
