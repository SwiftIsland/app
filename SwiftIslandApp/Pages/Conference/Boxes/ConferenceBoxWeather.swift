//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct ConferenceBoxWeather: View {
    @EnvironmentObject private var appDataModel: AppDataModel

    @State var weather: CurrentWeather?

    private let measureFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Texel Weather".uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
                .padding(.top, 6)
                .padding(.bottom, 0)
            ZStack {
                Image("WeatherBox")
                    .resizable()
                    .aspectRatio(CGSize(width: 550, height: 350), contentMode: .fill)
                VStack {
                    if let weather {
                        Image(systemName: "\(weather.symbolName).fill", variableValue: 100)
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 82))
                            .fontWeight(.light)
                            .foregroundColor(.white)
                            .shadow(color: .white, radius: 0.3, x: 0, y: 0.3)
                        Text(measureFormatter.string(from: weather.temperature))
                            .padding(5)
                            .fontWeight(.light)
                            .font(.title)
                            .foregroundColor(.white)
                            .shadow(color: .white, radius: 0.3, x: 0, y: 0.3)
                    } else {
                        ProgressView()
                            .tint(.white)
                    }
                }
            }
            .mask {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
            }
            .padding(.horizontal)
            Text("The weather right now @ Texel, the Netherlands.")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 20)
                .padding(.top, 0)
                .padding(.bottom, 12)
        }
        .onAppear {
            if !isPreview {
                Task {
                    weather = await appDataModel.getCurrentWeather()
                }
            }
        }
    }
}
