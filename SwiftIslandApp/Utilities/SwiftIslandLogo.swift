//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct SwiftIslandLogo: View {
    let isAnimating: Bool

    @State private var shapeColorsTopLeft = Color.yellowDark
    @State private var shapeColorsTopRight = Color.yellowLight
    @State private var shapeColorsMiddleLeft = Color.orangeLight
    @State private var shapeColorsMiddleRight = Color.orangeDark
    @State private var shapeColorsBottomLeft = Color.redDark
    @State private var shapeColorsBottomRight = Color.redLight

    @State private var animationDuration = 0.75 * 6
    @State private var rotationTopLeft = 0.0
    @State private var rotationTopRight = 0.0
    @State private var rotationMiddleLeft = 0.0
    @State private var rotationMidldleRight = 0.0
    @State private var rotationBottomLeft = 0.0
    @State private var rotationBottomRight = 0.0
    @State private var animateIn = false
    @State private var anchor: UnitPoint = .bottom


    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Triangle()
                    .fill(shapeColorsTopRight)
                    .aspectRatio(CGSize(width: 2, height: 1), contentMode: .fit)
                    .rotationEffect(Angle(degrees: 180))
                    .padding(0)
                    .rotation3DEffect(
                        Angle(degrees: rotationTopRight),
                        axis: (x: 1.0, y: 0, z: 0),
                        anchor: anchor,
                        perspective: 0
                    )
                    .percentageOffset(x: 0.75)
                    .onReceive(Timer.publish(every: animationDuration, on: .main, in: .common).autoconnect()) { _ in
                        animateRotation(rotation: $rotationTopRight, order: 0, reverse: true)
                    }
                Triangle()
                    .fill(shapeColorsTopLeft)
                    .aspectRatio(CGSize(width: 2, height: 1), contentMode: .fit)
                    .padding(0)
                    .rotation3DEffect(
                        Angle(degrees: rotationTopLeft),
                        axis: (x: 1.0, y: 0, z: 0),
                        anchor: anchor,
                        perspective: 0
                    )
                    .percentageOffset(x: -0.75)
                    .onReceive(Timer.publish(every: animationDuration, on: .main, in: .common).autoconnect()) { _ in
                        animateRotation(rotation: $rotationTopLeft, order: 1)
                    }
            }
            HStack(spacing: 0) {
                Triangle()
                    .fill(shapeColorsMiddleLeft)
                    .aspectRatio(CGSize(width: 2, height: 1), contentMode: .fit)
                    .rotationEffect(Angle(degrees: 180))
                    .padding(0)
                    .rotation3DEffect(
                        Angle(degrees: rotationMiddleLeft),
                        axis: (x: 1.0, y: 0, z: 0),
                        anchor: anchor,
                        perspective: 0
                    )

                    .percentageOffset(x: 0.25)
                    .onReceive(Timer.publish(every: animationDuration, on: .main, in: .common).autoconnect()) { _ in
                        animateRotation(rotation: $rotationMiddleLeft, order: 2, reverse: true)
                    }
                Triangle()
                    .fill(shapeColorsMiddleRight)
                    .aspectRatio(CGSize(width: 2, height: 1), contentMode: .fit)
                    .padding(0)
                    .rotation3DEffect(
                        Angle(degrees: rotationMidldleRight),
                        axis: (x: 1.0, y: 0, z: 0),
                        anchor: anchor,
                        perspective: 0
                    )
                    .percentageOffset(x: -0.25)
                    .onReceive(Timer.publish(every: animationDuration, on: .main, in: .common).autoconnect()) { _ in
                        animateRotation(rotation: $rotationMidldleRight, order: 3)
                    }
            }
            HStack(spacing: 0) {
                Triangle()
                    .fill(shapeColorsBottomRight)
                    .aspectRatio(CGSize(width: 2, height: 1), contentMode: .fit)
                    .rotationEffect(Angle(degrees: 180))
                    .padding(0)
                    .rotation3DEffect(
                        Angle(degrees: rotationBottomRight),
                        axis: (x: 1.0, y: 0, z: 0),
                        anchor: anchor,
                        perspective: 0
                    )
                    .percentageOffset(x: 0.75)
                    .onReceive(Timer.publish(every: animationDuration, on: .main, in: .common).autoconnect()) { _ in
                        animateRotation(rotation: $rotationBottomRight, order: 4, reverse: true)
                    }
                Triangle()
                    .fill(shapeColorsBottomLeft)
                    .aspectRatio(CGSize(width: 2, height: 1), contentMode: .fit)
                    .padding(0)
                    .rotation3DEffect(
                        Angle(degrees: rotationBottomLeft),
                        axis: (x: 1.0, y: 0, z: 0),
                        anchor: anchor,
                        perspective: 0
                    )

                    .percentageOffset(x: -0.75)
                    .onReceive(Timer.publish(every: animationDuration, on: .main, in: .common).autoconnect()) { _ in
                        animateRotation(rotation: $rotationBottomLeft, order: 5)
                    }
            }
        }
        .shadow(radius: 0)
        .padding(0)
    }

    private func animateRotation(rotation: Binding<Double>, order: Int = 0, reverse: Bool = false) {
        if isAnimating {
            withAnimation(.interpolatingSpring(mass: 1, stiffness: 200, damping: 40, initialVelocity: 0).delay(0.75 * Double(order))) {
                let new: Double = animateIn ? 0 : (reverse ? -90 : 90)
                rotation.wrappedValue = new
                if order == 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration - 0.01) {
                        animateIn.toggle()
                        anchor = animateIn ? .bottom : .top
                    }
                }
            }
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
