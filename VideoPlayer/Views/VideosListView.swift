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
                skeletonGrid
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
        .navigationTitle("Popular Videos")
        .navigationBarTitleDisplayMode(.large)
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
                ForEach(viewModel.videos, id: \.id) { video in
                    if let index = viewModel.videos.firstIndex(where: { $0.id == video.id }) {
                        TileDropView(columnIndex: index % Layout.gridColumnCount) {
                            listItemView(video: video)
                        }
                        .onTapGesture {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()

                            guard let correctIndex = viewModel.videos.firstIndex(where: { $0.id == video.id }) else { return }

                            coordinator.goToPlayVideoPage(
                                videoList: viewModel.videos,
                                selectedIndex: correctIndex
                            )
                        }
                        .onAppear {
                            Task {
                                await viewModel.loadMoreIfNeeded(index: index)
                            }
                        }
                    }
                }
            }
            if viewModel.isNextPageLoading {
                ProgressView()
                    .padding()
                    .listRowSeparator(.hidden)
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
    func listItemView(video: Video) -> some View {
        VideosListItemView(thumbnailURL: video.image,
                           videographerName: video.user.name,
                           duration: video.duration)

    }

    var skeletonGrid: some View {
        ScrollView {
            LazyVGrid(columns: gridItems) {
                ForEach(0..<Layout.skeletonItemCount, id: \.self) { _ in
                    VStack(alignment: .leading, spacing: Layout.skeletonTextSpacing) {
                        ShimmerView()
                            .frame(height: Layout.skeletonThumbnailHeight)
                            .cornerRadius(Layout.skeletonCornerRadius)
                        ShimmerView()
                            .frame(height: Layout.skeletonTextHeight)
                            .cornerRadius(Layout.skeletonTextCornerRadius)
                    }
                }
            }
        }
        .padding(.horizontal, Layout.horizontalPadding)
    }
}

private extension VideosListView {
    enum Layout {
        static let gridColumnCount = 3
        static let horizontalPadding: CGFloat = 6
        static let skeletonItemCount = 12
        static let skeletonThumbnailHeight: CGFloat = 180
        static let skeletonCornerRadius: CGFloat = 12
        static let skeletonTextHeight: CGFloat = 14
        static let skeletonTextCornerRadius: CGFloat = 4
        static let skeletonTextSpacing: CGFloat = 6
    }
}

private enum TileDropLayout {
    static let dropDistance: CGFloat = 30
    static let springResponse: Double = 0.45
    static let springDamping: Double = 0.7
    static let columnStaggerDelay: Double = 0.08
}

private struct TileDropView<Content: View>: View {
    let columnIndex: Int
    @ViewBuilder let content: Content
    @State private var appeared = false

    var body: some View {
        content
            .offset(y: appeared ? 0 : TileDropLayout.dropDistance)
            .opacity(appeared ? 1 : 0)
            .animation(
                .spring(response: TileDropLayout.springResponse, dampingFraction: TileDropLayout.springDamping)
                .delay(Double(columnIndex) * TileDropLayout.columnStaggerDelay),
                value: appeared
            )
            .onAppear {
                appeared = true
            }
    }
}
