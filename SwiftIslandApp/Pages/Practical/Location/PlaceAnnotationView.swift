//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct PlaceAnnotationView: View {
    @State private var showTitle = false
    let location: Location

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text(location.title)
                    .font(.callout)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 9)
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(10)
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.caption)
                    .foregroundColor(Color.secondarySystemGroupedBackground)
                    .offset(x: 0, y: -2)
            }
            .opacity(showTitle ? 1 : 0)
            .padding(.bottom, 2)

            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(location.type.color)

            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                .foregroundColor(location.type.color)
                .offset(x: 0, y: -5)
        }
        .onTapGesture {
            withAnimation(.easeInOut) {
                showTitle.toggle()
            }
        }
    }
}

struct PlaceAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                Color.purple
                PlaceAnnotationView(location: Location.forPreview())
            }
            .previewDisplayName("Light")
            .preferredColorScheme(.light)
            ZStack {
                Color.purple
                PlaceAnnotationView(location: Location.forPreview())
            }
            .previewDisplayName("Dark")
            .preferredColorScheme(.dark)
        }
    }
}
