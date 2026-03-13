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
    
    let gridItems: [GridItem] = Array(
        repeating: .init(.flexible()),
        count: Layout.gridColumnCount
    )
    
    var body: some View {
        VStack {
            
            if viewModel.isLoading {
                
                ProgressView()
                
            } else if viewModel.showInitialError {
                
                ErrorScreen(
                    message: viewModel.errorMessage
                ) {
                    Task {
                        await viewModel.getVideosInitial()
                    }
                }
                
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
                    listItemView(thumbnailURL: video.image,
                                 videographerName: video.user.name,
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
            
            if viewModel.showPaginationError {
                VStack {
                    Text("Failed to load more videos")
                    Button("Retry") {
                        Task {
                            await viewModel.loadMoreIfNeeded(
                                index: viewModel.videos.count - Constants.paginationPrefetchOffset
                            )
                        }
                    }
                }
                .padding()
            }
        }
        .padding(.horizontal, Layout.horizontalPadding)
    }
    
    @ViewBuilder
    func listItemView(thumbnailURL: URL, videographerName: String, duration: Int, index: Int) -> some View {
        VideosListItemView(thumbnailURL: thumbnailURL,
                           videographerName: videographerName,
                           duration: duration)
        .onTapGesture {
            let videosForPlayer = viewModel.videos
            coordinator.goToPlayVideoPage(videoList: videosForPlayer, selectedIndex: index)
        }
        
    }
}

private extension VideosListView {
    enum Layout {
        static let gridColumnCount = 3
        static let horizontalPadding: CGFloat = 6
    }
}
