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
            Task {
                await viewModel.getVideosInitial()
            }
        }
    }
    
    
    @ViewBuilder
    var listView: some View {
        List {
            LazyVGrid(columns: gridItems) {
                ForEach(viewModel.videos, id: \.id) { video in
                    listItemView(thumbNail: video.image,
                                 videoGrapherName: video.user.name,
                                 duration: video.duration,
                                 index: video.id)
                }
            }
            if viewModel.hasMore {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        Task {
                            await viewModel.loadMoreIfNeeded()
                        }
                    }
            }
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder
    func listItemView(thumbNail: URL, videoGrapherName: String, duration: Int, index: Int) -> some View {
        VideosListItemView(thumbNail: thumbNail,
                           videoGrapherName: videoGrapherName,
                           duration: duration)
        .onTapGesture {
            coordinator.goToPlayVideoPage()
        }
    }

}
