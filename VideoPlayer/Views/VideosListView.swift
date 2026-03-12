//
//  VideosListView.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import SwiftUI

struct VideosListView: View {
    @StateObject var viewModel: VideoListViewModel = VideoListViewModel()
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    let gridItems: [GridItem] = [.init(.flexible()), .init(.flexible()), .init(.flexible())]
    
    var body: some View {
        VStack {
            if viewModel.loading {
                ProgressView()
            } else {
                listView
            }
        }
        .ignoresSafeArea()
        .onAppear {
            if viewModel.videos.isEmpty {
                Task {
                    await viewModel.getVideosInitial()
                }
            }
        }
    }
    
    
    @ViewBuilder
    var listView: some View {
        ScrollView {
            LazyVGrid(columns: gridItems) {
                ForEach(Array(viewModel.videos.enumerated()), id: \.element.id) { index, video in
                    listItemView(thumbNail: video.image,
                                 videoGrapherName: video.user.name,
                                 duration: video.duration,
                                 index: index)
                    .onAppear {
                        Task {
                            await viewModel.loadMoreIfNeeded(index: index)
                        }
                    }
                }
            }
            if viewModel.isNextPageLoading {
                ProgressView().listRowSeparator(.hidden)
            }
        }
        .padding(.horizontal, 6)
    }
    
    @ViewBuilder
    func listItemView(thumbNail: URL, videoGrapherName: String, duration: Int, index: Int) -> some View {
        VideosListItemView(thumbNail: thumbNail,
                           videoGrapherName: videoGrapherName,
                           duration: duration)
        .onTapGesture {
            let videosForPlayer = viewModel.videos
            coordinator.goToPlayVideoPage(videoList: videosForPlayer, selectedIndex: index)
        }
        
    }
}
