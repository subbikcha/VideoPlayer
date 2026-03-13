//
//  VideoPlayerViewModel.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import Foundation

class VideoPlayerViewModel: ObservableObject {

    @Published var videos: [Video]
    @Published var currentIndex: Int
    @Published var showUpNext: Bool = false
    @Published var isVideoLoading = false
    @Published var videoError = false

    init(videos: [Video], selectedIndex: Int) {
        self.videos = videos
        self.currentIndex = selectedIndex
    }

    var currentVideo: Video {
        videos[currentIndex]
    }
    
    func toggleUpNext() {
        showUpNext.toggle()
    }

    var nextVideos: [Video] {
        Array(videos[currentIndex..<videos.count])
    }

    func playNextVideo() {
        guard currentIndex + 1 < videos.count else { return }
        currentIndex += 1
    }

    func selectVideo(at index: Int) {
        currentIndex = index
    }
    
    func getVideoUrl() -> URL? {
        guard let url =
                currentVideo.videoFiles.first(where: { $0.quality == Constants.preferredVideoQuality })?.link
                ?? currentVideo.videoFiles.first?.link else { return nil }
        return url
    }
}
