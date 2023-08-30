//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

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

            location.type.icon
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
                VStack {
                    PlaceAnnotationView(location: Location.forPreview(type: .venue))
                    PlaceAnnotationView(location: Location.forPreview(type: .restaurant))
                    PlaceAnnotationView(location: Location.forPreview(type: .poi))
                    PlaceAnnotationView(location: Location.forPreview(type: .bungalow))
                    PlaceAnnotationView(location: Location.forPreview(type: .workshopRoom))
                    PlaceAnnotationView(location: Location.forPreview(type: .restroom))
                    PlaceAnnotationView(location: Location.forPreview(type: .parking))
                    PlaceAnnotationView(location: Location.forPreview(type: .unknown))
                }
            }
            .previewDisplayName("Light")
            .preferredColorScheme(.light)
            ZStack {
                Color.black
                VStack {
                    PlaceAnnotationView(location: Location.forPreview(type: .venue))
                    PlaceAnnotationView(location: Location.forPreview(type: .restaurant))
                    PlaceAnnotationView(location: Location.forPreview(type: .poi))
                    PlaceAnnotationView(location: Location.forPreview(type: .bungalow))
                    PlaceAnnotationView(location: Location.forPreview(type: .workshopRoom))
                    PlaceAnnotationView(location: Location.forPreview(type: .restroom))
                    PlaceAnnotationView(location: Location.forPreview(type: .parking))
                    PlaceAnnotationView(location: Location.forPreview(type: .unknown))
                }
            }
            .previewDisplayName("Dark")
            .preferredColorScheme(.dark)
        }
    }
}
