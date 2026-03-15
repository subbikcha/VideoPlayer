//
//  ErrorView.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 12/03/26.
//

import Foundation
import SwiftUI

struct ErrorScreen: View {
    let message: String
    let retry: () -> Void

    var body: some View {

        VStack(spacing: Layout.spacing) {

            Image(systemName: Constants.SFSymbol.wifiSlash)
                .font(.largeTitle)

            Text(message)
                .multilineTextAlignment(.center)

            Button(Constants.Strings.retry) {
                retry()
            }
            .accessibilityIdentifier(Constants.AccessibilityID.retryButton)
        }
        .padding()
        .accessibilityIdentifier(Constants.AccessibilityID.errorScreen)
    }
}

private extension ErrorScreen {
    enum Layout {
        static let spacing: CGFloat = 16
    }
}
