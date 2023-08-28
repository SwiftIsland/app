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
                        Text("This app is created by Paul Peelen for use with the Swift Island 2023 conference. Swift Island owns a copy of the source code given that the code is shared publicly via Github to anyone interested in improving this app for future conferences.\n\nThe source code will be shared at the start of the conference.")
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
                        HStack() {
                            Spacer()
                            Button {
                                let url = URL(string: "https://PaulPeelen.com")!
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
                                let url = URL(string: "https://mastodon.nu/@ppeelen")!
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
                                let url = URL(string: "https://www.twitter.com/ppeelen")!
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
                        Button("Twitter @SwiftIslandNL") {
                            let url = URL(string: "https://www.twitter.com/swiftislandnl")!
                            UIApplication.shared.open(url)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.right")
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Button("Swift Island @ Github") {
                                let url = URL(string: "https://www.github.com/SwiftIsland/app")!
                                UIApplication.shared.open(url)
                            }
                            Text("_The repo might not yet be public, but when it is... you'll find it here._")
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
