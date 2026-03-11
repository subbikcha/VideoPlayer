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
        NavigationStack(path: $navigationCoordinator.paths) {
            VideosListView()
                .navigationDestination(for: Path.self) { path in
                    switch path {
                    case Path.videoPlay:
                        VideoPlayerPage()
                    case Path.videoList:
                        VideosListView()
                    }
                }
        }
        .environmentObject(navigationCoordinator)
    }
}
