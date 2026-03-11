//
//  NavigationCoordinators.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import Foundation
import SwiftUI

enum Path: Hashable {
    case videoPlay
    case videoList
}

class NavigationCoordinator: ObservableObject {
    @Published var paths: NavigationPath = NavigationPath()

    func goToPlayVideoPage() {
        paths.append(Path.videoPlay)
    }

    func goToVideoListPage() {
        paths.append(Path.videoList)
    }

    func logout() {
        paths = NavigationPath()
        goToVideoListPage()
    }
}
