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
                ZStack(alignment: .bottomTrailing) {
                    imageView()
                        .clipped()
                        .cornerRadius(Layout.cornerRadius)
                        .frame(height: Layout.thumbnailHeight)
                    durationBadge
                }

                Text(videographerName)
                    .font(.caption)
                    .bold()
                    .lineLimit(Layout.nameLineLimit, reservesSpace: true)
            }
        
    }
    
    @MainActor
    @ViewBuilder
    func imageView() -> some View {
        GeometryReader { geo in
            LazyImage(url: thumbnailURL) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if state.isLoading {
                    ZStack {
                        Color.gray.opacity(Layout.placeholderLoadingOpacity)
                        ProgressView()
                    }
                } else {
                    Color.gray.opacity(Layout.placeholderErrorOpacity)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    var durationBadge: some View {
        Text("\(duration)s")
            .font(.caption2)
            .bold()
            .padding(.horizontal, Layout.badgeHorizontalPadding)
            .padding(.vertical, Layout.badgeVerticalPadding)
            .background(.black.opacity(Layout.badgeBackgroundOpacity))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: Layout.badgeCornerRadius))
            .padding(Layout.badgePadding)
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
        static let badgeBackgroundOpacity: Double = 0.75
        static let placeholderLoadingOpacity: Double = 0.2
        static let placeholderErrorOpacity: Double = 0.3
    }
}
