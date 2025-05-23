//
//  VideoPlayApp.swift
//  VideoPlay
//
//  Created by Andrei Simedre on 23.05.2025.
//

import SwiftUI
import AVKit

@main
struct VideoPlayApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    do {
                        let audioSession = AVAudioSession.sharedInstance()
                        try audioSession.setCategory(.playback, mode: .default, options: [])
                        try audioSession.setActive(true)
                        print("Audio session configured and activated for playback.")
                    } catch {
                        print("Failed to set up audio session: \(error)")
                    }
                }
        }
    }
}
