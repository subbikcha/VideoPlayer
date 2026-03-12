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
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomTrailing) {
                VideoPlayer(player: player)
                    .aspectRatio(16/9, contentMode: .fit)
                    .onAppear {
                        playCurrentVideo()
                    }
                toggleArrow
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
            }
            
            if viewModel.showUpNext {
                VStack(alignment: .leading) {
                    
                    Text("Up Next")
                        .font(.headline)
                        .padding(.horizontal)
                    nextVideosCarousel
                }
                .padding(.top, 10)
                .background(.ultraThinMaterial)
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.showUpNext)
    }
    
    private var toggleArrow: some View {
        Button {
            viewModel.showUpNext.toggle()
        } label: {
            Image(systemName: viewModel.showUpNext ?
                  "chevron.down.circle.fill" :
                    "chevron.up.circle.fill")
            .font(.system(size: 34))
            .foregroundColor(.white)
            .padding(.bottom, 10)
        }
    }
    
    private var nextVideosCarousel: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(Array(viewModel.nextVideos.enumerated()),
                            id: \.element.id) { index, video in
                        
                        thumbnailView(video: video)
                            .frame(width: 140, height: 90)
                            .padding(4)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        index == 0 ? Color.yellow : Color.clear,
                                        lineWidth: 3
                                    )
                            )
                            .scaleEffect(index == 0 ? 1.05 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: index)
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
                    Color.gray.opacity(0.2)
                    ProgressView()
                }
            } else {
                Color.gray.opacity(0.3)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

private extension VideoPlayerPage {
    func playCurrentVideo() {
        guard let url = viewModel.getVideoUrl() else { return }
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { _ in
            playNextVideo()
        }
        player.play()
    }
    
    func playNextVideo() {
        viewModel.playNextVideo()
        playCurrentVideo()
    }
}
