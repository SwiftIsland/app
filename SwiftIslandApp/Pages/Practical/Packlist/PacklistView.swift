//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Defaults

struct PacklistView: View {
    @Namespace private var namespace
    @EnvironmentObject private var appDataModel: AppDataModel

    @State private var packingItems: [PackingItem] = []

    var body: some View {
        List {
            Section {
                let unpackedItems = packingItems.filter { !$0.checked }

                if unpackedItems.isEmpty {
                    VStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                            .font(.title)
                            .padding()
                        Text("All done! It seems you have packed all the items from the list!\n\n🎒 💪🏻")
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    ForEach(packingItems.filter { !$0.checked }) { packingItem in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(packingItem.title)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                Text(packingItem.subTitle)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button {
                                withAnimation {
                                    toggleItem(packingItem)
                                }
                            } label: {
                                Image(systemName: "circle")
                            }
                        }
                        .matchedGeometryEffect(id: packingItem.id, in: namespace)
                    }
                }
            } header: {
                Text("Unpacked")
            }

            Section {
                ForEach(packingItems.filter { $0.checked }) { packingItem in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(packingItem.title)
                                .font(.body)
                                .foregroundColor(.primary)
                            Text(packingItem.subTitle)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button {
                            withAnimation {
                                toggleItem(packingItem)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                    .matchedGeometryEffect(id: packingItem.id, in: namespace)
                }
            } header: {
                Text("Already Packed")
            } footer: {
                Text("All items in this list are stored locally in your user defaults and not shared with others.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            Task {
                self.packingItems = await appDataModel.fetchPackingListItems()
            }
        }
        .navigationTitle("Packlist")
    }

    func toggleItem(_ packingItem: PackingItem) {
        let items = packingItems.map {
            var item = $0
            if $0.id == packingItem.id {
                item.checked = !$0.checked
            }
            return item
        }
        self.packingItems = items
        Defaults[.packingItems] = items
    }
}

struct PacklistView_Previews: PreviewProvider {
    static var previews: some View {
        PacklistView()
            .environmentObject(AppDataModel())
    }
}
