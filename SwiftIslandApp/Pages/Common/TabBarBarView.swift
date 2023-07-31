//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct TabBarBarView: View {
    @Binding var selectedItem: Tab

    init(selectedItem: Binding<Tab>) {
        _selectedItem = selectedItem
    }

    var body: some View {
        HStack {
            Spacer()
            ForEach(Tab.availableItems, id:\.self) { tab in
                let tabItem = tab.tabItem
                Button {
                    selectedItem = tab
                } label: {
                    VStack {
                        Image(systemName: tabItem.imageName)
                            .symbolVariant(tab == selectedItem ? .fill : .none)
                            .font(.body.bold())
                            .frame(width: 44, height: 20)
                            .fontWeight(tab == selectedItem ? .regular : .light)
                        Text(tabItem.title)
                            .font(.caption2)
                            .lineLimit(1)
                            .fontWeight(tab == selectedItem ? .regular : .light)
                    }
                    .frame(maxWidth: .infinity)
                    Spacer()
                }
                .foregroundStyle(tab == selectedItem ? .primary : .secondary)
                .buttonStyle(.plain)
            }
        }
        .padding(.top)
        .frame(height: 88, alignment: .top)
        .background(.ultraThinMaterial)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
    }
}

struct TabBarBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabBarBarView(selectedItem: .constant(.home))
                .previewDisplayName("Light Mode")
            TabBarBarView(selectedItem: .constant(.home))
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
