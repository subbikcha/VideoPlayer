//
//  VideoPlayerPage.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import SwiftUI
import AVKit
import NukeUI

struct VideoPlayerPage: View {
    
    @StateObject var viewModel: VideoPlayerViewModel
    @State private var player = AVPlayer()
    @State private var playerItemObserver: NSKeyValueObservation?
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomTrailing) {
                VideoPlayer(player: player)
                    .aspectRatio(Layout.videoAspectRatio, contentMode: .fit)
                    .onAppear {
                         playCurrentVideo()
                     }

                if viewModel.isVideoLoading {
                    loadingView
                }
                
                if viewModel.videoError {
                    errorView
                 }

                toggleArrow
                    .padding(.trailing, Layout.toggleTrailingPadding)
                    .padding(.bottom, Layout.toggleBottomPadding)
            }
            
            if viewModel.showUpNext {
                showUpNextView
            }
        }
        .animation(.easeInOut(duration: Layout.panelAnimationDuration), value: viewModel.showUpNext)
    }
    
}

private extension VideoPlayerPage {
    enum Layout {
        static let videoAspectRatio: CGFloat = 16.0 / 9.0
        static let toggleIconSize: CGFloat = 34
        static let toggleTrailingPadding: CGFloat = 16
        static let toggleBottomPadding: CGFloat = 16
        static let toggleIconBottomPadding: CGFloat = 10
        static let panelAnimationDuration: TimeInterval = 0.25
        static let upNextTopPadding: CGFloat = 10
        static let loadingIndicatorScale: CGFloat = 1.5
        static let errorSpacing: CGFloat = 10
        static let retryHorizontalPadding: CGFloat = 20
        static let retryVerticalPadding: CGFloat = 8
        static let thumbnailWidth: CGFloat = 140
        static let thumbnailHeight: CGFloat = 90
        static let thumbnailPadding: CGFloat = 4
        static let thumbnailCornerRadius: CGFloat = 8
        static let thumbnailInnerCornerRadius: CGFloat = 6
        static let highlightBorderWidth: CGFloat = 3
        static let highlightScale: CGFloat = 1.05
        static let carouselSpacing: CGFloat = 15
        static let thumbnailAnimationDuration: TimeInterval = 0.2
        static let placeholderLoadingOpacity: Double = 0.2
        static let placeholderErrorOpacity: Double = 0.3
    }
}

private extension VideoPlayerPage {
    private var loadingView: some View {
        ZStack {
            Color.black
            ProgressView()
                .scaleEffect(Layout.loadingIndicatorScale)
                .tint(.white)
        }
        .aspectRatio(Layout.videoAspectRatio, contentMode: .fit)
    }
    
    private var errorView: some View {
        VStack(spacing: Layout.errorSpacing) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.white)
            Text("Failed to play video")
                .foregroundColor(.white)
            Button("Retry") {
                playCurrentVideo()
            }
            .padding(.horizontal, Layout.retryHorizontalPadding)
            .padding(.vertical, Layout.retryVerticalPadding)
            .background(.white)
            .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
    
    private var showUpNextView: some View {
        VStack(alignment: .leading) {
            Text("Up Next")
                .font(.headline)
                .padding(.horizontal)
            nextVideosCarousel
        }
        .padding(.top, Layout.upNextTopPadding)
        .background(.ultraThinMaterial)
        .transition(.move(edge: .bottom))
    }
    
    private var toggleArrow: some View {
        Button {
            viewModel.showUpNext.toggle()
        } label: {
            Image(systemName: viewModel.showUpNext ?
                  "chevron.down.circle.fill" :
                    "chevron.up.circle.fill")
            .font(.system(size: Layout.toggleIconSize))
            .foregroundColor(.white)
            .padding(.bottom, Layout.toggleIconBottomPadding)
        }
    }
    
    private var nextVideosCarousel: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Layout.carouselSpacing) {
                    ForEach(Array(viewModel.nextVideos.enumerated()),
                            id: \.element.id) { index, video in
                        
                        thumbnailView(video: video)
                            .frame(width: Layout.thumbnailWidth, height: Layout.thumbnailHeight)
                            .padding(Layout.thumbnailPadding)
                            .clipShape(RoundedRectangle(cornerRadius: Layout.thumbnailCornerRadius))
                            .overlay(
                                RoundedRectangle(cornerRadius: Layout.thumbnailCornerRadius)
                                    .stroke(
                                        index == 0 ? Color.yellow : Color.clear,
                                        lineWidth: Layout.highlightBorderWidth
                                    )
                            )
                            .scaleEffect(index == 0 ? Layout.highlightScale : 1.0)
                            .animation(.easeInOut(duration: Layout.thumbnailAnimationDuration), value: index)
                            .id(index)
                            .onTapGesture {
                                viewModel.selectVideo(at: viewModel.currentIndex + index)
                                playCurrentVideo()
                                proxy.scrollTo(0, anchor: .leading)
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func thumbnailView(video: Video) -> some View {
        LazyImage(url: video.image) { state in
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
        .clipShape(RoundedRectangle(cornerRadius: Layout.thumbnailInnerCornerRadius))
    }
}

private extension VideoPlayerPage {
    func playCurrentVideo() {
        NotificationCenter.default.removeObserver(self)
        guard let url = viewModel.getVideoUrl() else {
            viewModel.videoError = true
            return
        }
        viewModel.isVideoLoading = true
        viewModel.videoError = false
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        playerItemObserver = player.observe(\.timeControlStatus, options: [.new]) { player, _ in
            DispatchQueue.main.async {

                if player.timeControlStatus == .playing {
                    viewModel.isVideoLoading = false
                }

                if player.timeControlStatus == .waitingToPlayAtSpecifiedRate {
                    viewModel.isVideoLoading = true
                }
            }
        }
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemFailedToPlayToEndTime,
            object: item,
            queue: .main
        ) { _ in
            viewModel.videoError = true
            viewModel.isVideoLoading = false
        }
        player.play()
    }
    
    func playNextVideo() {
        viewModel.playNextVideo()
        playCurrentVideo()
    }
}
