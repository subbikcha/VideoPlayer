//
//  ContentView.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var navigationCoordinator: NavigationCoordinator = NavigationCoordinator()
    
    var body: some View {
        NavigationStack(path: $navigationCoordinator.navigationPath) {
            VideosListView()
                .navigationDestination(for: Path.self) { path in
                    switch path {
                    case Path.videoPlay(let videos, let index):
                        VideoPlayerPage(viewModel: VideoPlayerViewModel(
                            videos: videos,
                            selectedIndex: index
                        ))
                    case Path.videoList:
                        VideosListView()
                    }
                }
        }
        .environmentObject(navigationCoordinator)
    }
}
