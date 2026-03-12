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

        VStack(spacing: 16) {

            Image(systemName: "wifi.slash")
                .font(.largeTitle)

            Text(message)
                .multilineTextAlignment(.center)

            Button("Retry") {
                retry()
            }
        }
        .padding()
    }
}
