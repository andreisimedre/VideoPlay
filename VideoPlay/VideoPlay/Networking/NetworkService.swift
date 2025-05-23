//
//  NetworkService.swift
//  VideoPlay
//
//  Created by Andrei Simedre on 23.05.2025.
//

import Foundation

enum RequestMethod: String {
    case get = "GET"
}

struct ErrorResponse: Codable {
    let code: Int
    let message: String
}

enum VPError: Error {
    case serverError(_ err: ErrorResponse)
    case authError(_ err: ErrorResponse)
    case networkError(_ message: String)
    case urlError(_ message: String)
    case encodingError(_ message: String)
    case decodingError(_ message: String)

    var message: String {
        switch self {
        case .serverError(let err), .authError(let err):
            return err.message
        case .networkError(let message), .urlError(let message), .encodingError(let message), .decodingError(let message):
            return message
        }
    }
}

actor NetworkService: ObservableObject, Sendable {
    let API_KEY = ""
    let baseURL = "https://api.pexels.com/videos/search"

    let convertToSnakeCaseEncoder = JSONEncoder()
    let convertToCamelCaseDecoder = JSONDecoder()

    init() {
        convertToSnakeCaseEncoder.keyEncodingStrategy = .convertToSnakeCase
        convertToCamelCaseDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    private func formRequest(url: URL, method: String = RequestMethod.get.rawValue, contentType: String = "application/json") -> URLRequest {
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = method
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue(API_KEY, forHTTPHeaderField: "Authorization")

        return request
    }

    func doRequest<T: Decodable>(request: URLRequest) async throws(VPError) -> T {
        print("do request \(request.url?.absoluteString ?? "")")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw VPError.networkError(ErrorsMessage.ERR_CONVERTING_TO_HTTP_RESPONSE.message)
            }

            print("response code: \(httpResponse.statusCode)")

            if httpResponse.isSuccessful() {
                return try parseResponse(data: data)
            } else {
                return try parseError(data: data)
            }
        } catch {
            if error is URLError {
                throw VPError.networkError(ErrorsMessage.INVALID_URL.rawValue)
            } else {
                guard let error = error as? VPError else {
                    throw VPError.networkError(error.localizedDescription)
                }
                throw error
            }
        }
    }

    private func parseResponse<T: Decodable>(data: Data) throws(VPError) -> T {
        do {
            return try convertToCamelCaseDecoder.decode(T.self, from: data)
        } catch {
            print("failed parsing successful response, parsing err: \(error)")
            return try parseError(data: data)
        }
    }

    private func parseError<T>(data: Data) throws(VPError) -> T {
        print("parsing error")
        do {
            let errorResponse = try convertToCamelCaseDecoder.decode(ErrorResponse.self, from: data)
            throw VPError.serverError(errorResponse)
        } catch {
            guard let error = error as? VPError else {
                throw VPError.decodingError(ErrorsMessage.ERR_PARSE_RESPONSE.message)
            }
            throw error
        }
    }

    func getVideos(query: String? = nil) async throws(VPError) -> [Video] {
        var urlString = baseURL
        if let query = query {
            urlString = "\(baseURL)?query=\(query)"
        }
        guard let url = URL(string: urlString) else {
            throw VPError.networkError(ErrorsMessage.INVALID_URL.rawValue)
        }
        
        do {
            let request = formRequest(url: url, method: RequestMethod.get.rawValue)
            let videosResponse: ResponseBody = try await doRequest(request: request)
            return videosResponse.videos
        } catch {
            throw error
        }
    }
}
