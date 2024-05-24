//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct SourceView: View {
    var body: some View {
        ZStack {
            LinearGradient.defaultBackground

            List {
                Section {
                    VStack(alignment: .leading) {
                        Text("Disclaimer")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .padding(.bottom, 4)
                        Text("This app is created by Paul Peelen for use with the Swift Island 2024 conference. Swift Island owns a copy of the source code given that the code is shared publicly via Github to anyone interested, the link to this repository can be found below.") // swiftlint:disable:this line_length
                            .font(.callout)
                    }
                } header: {
                    VStack {
                        Image("paulp")
                            .resizable()
                            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                            .mask {
                                Circle()
                            }
                            .frame(maxWidth: UIScreen.main.bounds.width / 2, maxHeight: UIScreen.main.bounds.width / 2)
                        .padding(0)
                        HStack {
                            Spacer()
                            Button {
                                let url = URL(string: "https://PaulPeelen.com")! // swiftlint:disable:this force_unwrapping
                                UIApplication.shared.open(url)
                            } label: {
                                Image(systemName: "globe.europe.africa")
                                    .resizable()
                                    .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                                    .frame(width: 26)
                                    .fontWeight(.light)
                            }
                            Spacer()
                            Button {
                                let url = URL(string: "https://mastodon.nu/@ppeelen")! // swiftlint:disable:this force_unwrapping
                                UIApplication.shared.open(url)
                            } label: {
                                Image("mastodon-icon")
                                    .resizable()
                                    .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                                    .frame(width: 26)
                                    .fontWeight(.light)
                            }
                            Spacer()
                            Button {
                                let url = URL(string: "https://www.twitter.com/ppeelen")! // swiftlint:disable:this force_unwrapping
                                UIApplication.shared.open(url)
                            } label: {
                                Image("twitter-icon")
                                    .resizable()
                                    .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                                    .frame(width: 26)
                                    .fontWeight(.light)
                            }
                            Spacer()
                        }
                        .padding(.bottom)
                    }
                }

                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Button("Twitter @SwiftIslandNL") {
                                let url = URL(string: "https://www.twitter.com/swiftislandnl")! // swiftlint:disable:this force_unwrapping
                                UIApplication.shared.open(url)
                            }
                            Text("_Contribute to this app and make it even better, here you'll find the source code!_")
                                .font(.footnote)
                                .fontWeight(.light)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.right")
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Button("Swift Island @ Github") {
                                let url = URL(string: "https://www.github.com/SwiftIsland/app")! // swiftlint:disable:this force_unwrapping
                                UIApplication.shared.open(url)
                            }
                            Text("_Contribute to this app and make it even better, here you'll find the source code!_")
                                .font(.footnote)
                                .fontWeight(.light)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.right")
                    }
                } header: {
                    Text("Links")
                }
            }
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SourceView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SourceView()
                .preferredColorScheme(.light)
                .previewDisplayName("Light mode")
            SourceView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}
