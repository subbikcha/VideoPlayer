//
//  ShimmerView.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 13/03/26.
//

import SwiftUI

struct ShimmerView: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            Color.gray.opacity(Layout.baseOpacity)
                .overlay(
                    LinearGradient(
                        colors: [
                            .clear,
                            .white.opacity(Layout.shimmerOpacity),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * Layout.gradientWidthMultiplier)
                    .offset(x: -geo.size.width + (phase * geo.size.width * Layout.travelMultiplier))
                )
                .clipped()
        }
        .onAppear {
            withAnimation(
                .linear(duration: Layout.animationDuration)
                .repeatForever(autoreverses: false)
            ) {
                phase = 1
            }
        }
    }

    private enum Layout {
        static let baseOpacity: Double = 0.15
        static let shimmerOpacity: Double = 0.4
        static let gradientWidthMultiplier: CGFloat = 0.6
        static let travelMultiplier: CGFloat = 2.5
        static let animationDuration: TimeInterval = 1.2
    }
}
