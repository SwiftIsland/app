//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct SwiftIslandLogo: View {
    let isAnimating: Bool

    private let colorRange: [Color] = [.yellowLight, .yellowDark, .orangeLight, .orangeDark, .redLight, .redDark]
    private let minDuration = 1.0
    private let maxDuration = 2.0

    @State private var shapeColorsTopLeft = Color.yellowDark
    @State private var shapeColorsTopRight = Color.yellowLight
    @State private var shapeColorsMiddleLeft = Color.orangeLight
    @State private var shapeColorsMiddleRight = Color.orangeDark
    @State private var shapeColorsBottomLeft = Color.redDark
    @State private var shapeColorsBottomRight = Color.redLight

    @State private var durationAnimationTopLeft = 0.1
    @State private var durationAnimationTopRight = 0.1
    @State private var durationAnimationMiddleLeft = 0.1
    @State private var durationAnimationMiddleRight = 0.1
    @State private var durationAnimationBottomLeft = 0.1
    @State private var durationAnimationBottomRight = 0.1

    var body: some View {

        VStack(spacing: 0) {

            HStack(spacing: 0) {
                Triangle()
                    .fill(shapeColorsTopLeft)
                    .aspectRatio(CGSize(width: 2, height: 1), contentMode: .fit)
                    .padding(0)
                    .percentageOffset(x: 0.25)
                    .onReceive(Timer.publish(every: durationAnimationTopLeft, on: .main, in: .common).autoconnect()) { _ in
                        handleColorChange(shapeColor: $shapeColorsTopLeft, animationDuration: $durationAnimationTopLeft)
                    }
                Triangle()
                    .fill(shapeColorsTopRight)
                    .aspectRatio(CGSize(width: 2, height: 1), contentMode: .fit)
                    .rotationEffect(Angle(degrees: 180))
                    .padding(0)
                    .percentageOffset(x: -0.25)
                    .onReceive(Timer.publish(every: durationAnimationTopRight, on: .main, in: .common).autoconnect()) { _ in
                        handleColorChange(shapeColor: $shapeColorsTopRight, animationDuration: $durationAnimationTopRight)
                    }
            }
            HStack(spacing: 0) {
                Triangle()
                    .fill(shapeColorsMiddleLeft)
                    .aspectRatio(CGSize(width: 2, height: 1), contentMode: .fit)
                    .rotationEffect(Angle(degrees: 180))
                    .padding(0)
                    .percentageOffset(x: 0.25)
                    .onReceive(Timer.publish(every: durationAnimationMiddleLeft, on: .main, in: .common).autoconnect()) { _ in
                        handleColorChange(shapeColor: $shapeColorsMiddleLeft, animationDuration: $durationAnimationMiddleLeft)
                    }
                Triangle()
                    .fill(shapeColorsMiddleRight)
                    .aspectRatio(CGSize(width: 2, height: 1), contentMode: .fit)
                    .padding(0)
                    .percentageOffset(x: -0.25)
                    .onReceive(Timer.publish(every: durationAnimationMiddleRight, on: .main, in: .common).autoconnect()) { _ in
                        handleColorChange(shapeColor: $shapeColorsMiddleRight, animationDuration: $durationAnimationMiddleRight)
                    }
            }
            HStack(spacing: 0) {
                Triangle()
                    .fill(shapeColorsBottomLeft)
                    .aspectRatio(CGSize(width: 2, height: 1), contentMode: .fit)
                    .padding(0)
                    .percentageOffset(x: 0.25)
                    .onReceive(Timer.publish(every: durationAnimationBottomLeft, on: .main, in: .common).autoconnect()) { _ in
                        handleColorChange(shapeColor: $shapeColorsBottomLeft, animationDuration: $durationAnimationBottomLeft)
                    }
                Triangle()
                    .fill(shapeColorsBottomRight)
                    .aspectRatio(CGSize(width: 2, height: 1), contentMode: .fit)
                    .rotationEffect(Angle(degrees: 180))
                    .padding(0)
                    .percentageOffset(x: -0.25)
                    .onReceive(Timer.publish(every: durationAnimationBottomRight, on: .main, in: .common).autoconnect()) { _ in
                        handleColorChange(shapeColor: $shapeColorsBottomRight, animationDuration: $durationAnimationBottomRight)
                    }
            }
        }
        .shadow(radius: 0)
        .padding(0)
        .onAppear {
            durationAnimationTopLeft = Double.random(in: minDuration...maxDuration)
            durationAnimationTopRight = Double.random(in: minDuration...maxDuration)
            durationAnimationMiddleLeft = Double.random(in: minDuration...maxDuration)
            durationAnimationMiddleRight = Double.random(in: minDuration...maxDuration)
            durationAnimationBottomLeft = Double.random(in: minDuration...maxDuration)
            durationAnimationBottomRight = Double.random(in: minDuration...maxDuration)
        }
    }

    private func handleColorChange(shapeColor: Binding<Color>, animationDuration: Binding<Double>) {
        if isAnimating {
            withAnimation(.easeInOut(duration: animationDuration.wrappedValue)) {
                shapeColor.wrappedValue = colorRange.randomElement() ?? shapeColor.wrappedValue
            }
            animationDuration.wrappedValue = Double.random(in: minDuration...maxDuration)
        }
    }
}

struct SwiftIslandLogo_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SwiftIslandLogo(isAnimating: false)
                .previewDisplayName("Without animation")
            SwiftIslandLogo(isAnimating: false)
                .previewDisplayName("Without animation")
                .preferredColorScheme(.light)
            SwiftIslandLogo(isAnimating: true)
                .previewDisplayName("With animation")
                .padding(20)
                .shadow(radius: 20)
            SwiftIslandLogo(isAnimating: true)
                .previewDisplayName("With animation - Dark")
                .padding(20)
                .shadow(radius: 20)
                .preferredColorScheme(.dark)
        }
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}

