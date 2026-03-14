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
    @State private var observers: [NSObjectProtocol] = []
    @State private var videoTransitionID = UUID()
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack(alignment: .bottomTrailing) {
                VideoPlayer(player: player)
                    .aspectRatio(Layout.videoAspectRatio, contentMode: .fit)
                    .id(videoTransitionID)
                    .transition(.opacity)
                    .onAppear {
                         playCurrentVideo()
                     }
                    .onDisappear {
                        stopPlayer()
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

            Spacer()
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
        static let videoTransitionDuration: TimeInterval = 0.3
        static let upNextTopPadding: CGFloat = 10
        static let upNextBottomPadding: CGFloat = 10
        static let loadingIndicatorScale: CGFloat = 1.5
        static let errorSpacing: CGFloat = 10
        static let retryHorizontalPadding: CGFloat = 20
        static let retryVerticalPadding: CGFloat = 8
        static let thumbnailWidth: CGFloat = 130
        static let thumbnailImageHeight: CGFloat = 80
        static let thumbnailPadding: CGFloat = 4
        static let thumbnailCornerRadius: CGFloat = 8
        static let thumbnailInnerCornerRadius: CGFloat = 6
        static let highlightBorderWidth: CGFloat = 3
        static let highlightScale: CGFloat = 1.05
        static let carouselSpacing: CGFloat = 12
        static let thumbnailAnimationDuration: TimeInterval = 0.2
        static let placeholderLoadingOpacity: Double = 0.2
        static let placeholderErrorOpacity: Double = 0.3
        static let nameLineLimit = 1
        static let gradientWidth: CGFloat = 40
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
        VStack(alignment: .leading, spacing: 0) {
            Text("Up Next")
                .font(.headline)
                .padding(.horizontal)
                .padding(.bottom, 8)
            nextVideosCarousel
        }
        .padding(.top, Layout.upNextTopPadding)
        .padding(.bottom, Layout.upNextBottomPadding)
        .background(.ultraThinMaterial)
        .transition(.move(edge: .bottom))
        .accessibilityIdentifier("upNextPanel")
    }
    
    private var toggleArrow: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            viewModel.showUpNext.toggle()
        } label: {
            Image(systemName: viewModel.showUpNext ?
                  "chevron.down.circle.fill" :
                    "chevron.up.circle.fill")
            .font(.system(size: Layout.toggleIconSize))
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
            .padding(.bottom, Layout.toggleIconBottomPadding)
        }
        .accessibilityIdentifier("upNextToggle")
    }
    
    private var nextVideosCarousel: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Layout.carouselSpacing) {
                    ForEach(Array(viewModel.nextVideos.enumerated()),
                            id: \.element.id) { index, video in
                        
                        carouselItem(video: video, index: index)
                            .id(index)
                            .onTapGesture {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                viewModel.selectVideo(at: viewModel.currentIndex + index)
                                switchVideo()
                                proxy.scrollTo(0, anchor: .leading)
                            }
                    }
                }
                .padding(.horizontal)
            }
            .overlay(alignment: .trailing) {
                carouselFadeEdge
            }
        }
    }

    private func carouselItem(video: Video, index: Int) -> some View {
        let isCurrentlyPlaying = index == 0

        return VStack(spacing: 4) {
            thumbnailView(video: video)
                .frame(width: Layout.thumbnailWidth, height: Layout.thumbnailImageHeight)
                .clipShape(RoundedRectangle(cornerRadius: Layout.thumbnailCornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.thumbnailCornerRadius)
                        .stroke(
                            isCurrentlyPlaying ? Color.yellow : Color.clear,
                            lineWidth: Layout.highlightBorderWidth
                        )
                )
                .scaleEffect(isCurrentlyPlaying ? Layout.highlightScale : 1.0)
                .animation(.easeInOut(duration: Layout.thumbnailAnimationDuration), value: viewModel.currentIndex)

            Text(video.user.name)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(Layout.nameLineLimit)
                .frame(width: Layout.thumbnailWidth)
        }
    }

    private var carouselFadeEdge: some View {
        LinearGradient(
            colors: [.clear, Color(.systemBackground)],
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(width: Layout.gradientWidth)
        .allowsHitTesting(false)
    }
    
    private func thumbnailView(video: Video) -> some View {
        LazyImage(url: video.image) { state in
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFill()
            } else if state.isLoading {
                ShimmerView()
            } else {
                Color.gray.opacity(Layout.placeholderErrorOpacity)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: Layout.thumbnailInnerCornerRadius))
    }
}

private extension VideoPlayerPage {
    func stopPlayer() {

        player.pause()
        player.replaceCurrentItem(with: nil)

        playerItemObserver?.invalidate()
        playerItemObserver = nil

        for observer in observers {
            NotificationCenter.default.removeObserver(observer)
        }

        observers.removeAll()
    }
    
    func switchVideo() {
        withAnimation(.easeInOut(duration: Layout.videoTransitionDuration)) {
            videoTransitionID = UUID()
        }

        playCurrentVideo()
    }

    func playCurrentVideo() {

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

        let didFinishObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { _ in
            playNextVideo()
        }

        observers.append(didFinishObserver)

        let failedObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemFailedToPlayToEndTime,
            object: item,
            queue: .main
        ) { _ in
            viewModel.videoError = true
            viewModel.isVideoLoading = false
        }

        observers.append(failedObserver)

        player.play()
    }
    
    func playNextVideo() {
        guard viewModel.currentIndex + 1 < viewModel.videos.count else { return }

        viewModel.playNextVideo()
        switchVideo()
    }
}
