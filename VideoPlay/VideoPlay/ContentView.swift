//
//  ContentView.swift
//  VideoPlay
//
//  Created by Andrei Simedre on 23.05.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var networkService = NetworkService()
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 20)]

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(Query.allCases, id: \.self) { searchQuery in
                            QueryTag(query: searchQuery.rawValue, isSelected: networkService.selectedQuery == searchQuery)
                                .onTapGesture {
                                    networkService.selectedQuery = searchQuery
                                }
                        }
                    }
                }
                
                ScrollView {
                    if networkService.videos.isEmpty {
                        ProgressView()
                    } else {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(networkService.videos, id: \.id) { video in
                                NavigationLink {
                                    VideoView(video: video)
                                } label: {
                                    VideoCardView(video: video)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color("AccentColor"))
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
