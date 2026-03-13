//
//  VideoListItemView.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import Foundation
import SwiftUI
import NukeUI

struct VideosListItemView: View {
    let thumbnailURL: URL
    let videographerName: String
    let duration: Int

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.itemSpacing) {
            imageView()
                .frame(height: Layout.thumbnailHeight)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
                .shadow(
                    color: .black.opacity(Layout.shadowOpacity),
                    radius: Layout.shadowRadius,
                    x: 0,
                    y: Layout.shadowY
                )

            Text(videographerName)
                .font(.caption)
                .bold()
                .lineLimit(Layout.nameLineLimit, reservesSpace: true)
                .padding(.horizontal, 2)
        }
        .contentShape(Rectangle())
    }
    
    @MainActor
    @ViewBuilder
    func imageView() -> some View {
        ZStack(alignment: .bottomTrailing) {
            LazyImage(url: thumbnailURL) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if state.isLoading {
                    ShimmerView()
                } else {
                    Color.gray.opacity(Layout.placeholderErrorOpacity)
                }
            }
            .clipped()
            
            durationBadge
        }
    }

    var durationBadge: some View {
        Text(formattedDuration)
            .font(.caption2)
            .bold()
            .padding(.horizontal, Layout.badgeHorizontalPadding)
            .padding(.vertical, Layout.badgeVerticalPadding)
            .background(.ultraThinMaterial)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: Layout.badgeCornerRadius))
            .padding(Layout.badgePadding)
    }

    private var formattedDuration: String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

private extension VideosListItemView {
    enum Layout {
        static let thumbnailHeight: CGFloat = 180
        static let itemSpacing: CGFloat = 6
        static let cornerRadius: CGFloat = 12
        static let nameLineLimit = 2
        static let badgeCornerRadius: CGFloat = 6
        static let badgeHorizontalPadding: CGFloat = 8
        static let badgeVerticalPadding: CGFloat = 4
        static let badgePadding: CGFloat = 8
        static let placeholderErrorOpacity: Double = 0.3
        static let shadowOpacity: Double = 0.15
        static let shadowRadius: CGFloat = 6
        static let shadowY: CGFloat = 3
    }
}
