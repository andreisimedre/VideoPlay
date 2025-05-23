//
//  NetworkService.swift
//  VideoPlay
//
//  Created by Andrei Simedre on 23.05.2025.
//

import Foundation

actor NetworkService: ObservableObject, Sendable {
    let API_KEY = "uNJYRoKEQnumNABpnjaN0h9KCgi5h17gcI0gVySNa4oVcNRWNFf7MYns"
    let baseURL = "https://api.pexels.com/videos/search?query="

    @Published private(set) var videos: [Video] = []
    @Published var selectedQuery: Query = Query.sport {
        didSet {
            Task.init {
                try? await getVideos(query: selectedQuery.rawValue)
            }
        }
    }

    init() {

        Task.init {
            try? await getVideos(query: selectedQuery.rawValue)
        }
    }

    func getVideos(query: String) async throws {
        do {
            guard let url = URL(string: "\(baseURL)\(query)&per_page=10&orientation=portrait") else { fatalError("Missing URL") }
            print(url.absoluteString)
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue(API_KEY, forHTTPHeaderField: "Authorization")

            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let decodedData = try decoder.decode(ResponseBody.self, from: data)
            self.videos = []
            self.videos = decodedData.videos

        } catch {
            print("Error fetching data from Pexels: \(error)")
        }
    }
}
