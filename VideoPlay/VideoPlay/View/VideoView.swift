//
//  VideoView.swift
//  VideoPlay
//
//  Created by Andrei Simedre on 23.05.2025.
//

import SwiftUI
import AVKit

struct VideoView: View {
    var video: Video
    @State private var player: AVPlayer = AVPlayer()

    var body: some View {
        VideoPlayer(player: player)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                if let link = video.videoFiles.first?.link, let url = URL(string: link) {
                    player = AVPlayer(url: url)
                    player.play()
                }
            }
            .onDisappear {
                player.pause()
            }
    }
}

#Preview {
    VideoView(video: previewVideo)
}
