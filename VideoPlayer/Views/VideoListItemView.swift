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
    let thumbNail: URL
    let videoGrapherName: String
    let duration: Int

    var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                ZStack(alignment: .bottomTrailing) {
                    imageView()
                        .clipped()
                        .cornerRadius(12)
                        .frame(height: 180)
                    durationBadge
                }

                Text(videoGrapherName)
                    .font(.caption)
                    .bold()
                    .lineLimit(2, reservesSpace: true)
            }
        
    }
    
    @MainActor
    @ViewBuilder
    func imageView() -> some View {
        GeometryReader { geo in
            LazyImage(url: thumbNail) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if state.isLoading {
                    ZStack {
                        Color.gray.opacity(0.2)
                        ProgressView()
                    }
                } else {
                    Color.gray.opacity(0.3)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    var durationBadge: some View {
        Text("\(duration)s")
            .font(.caption2)
            .bold()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.black.opacity(0.75))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .padding(8)
    }
}
