//
//  Video.swift
//  VideoPlay
//
//  Created by Andrei Simedre on 23.05.2025.
//

import Foundation

struct ResponseBody: Codable {
    let page: Int
    let perPage: Int
    let videos: [Video]
}

// MARK: - Video
struct Video: Codable {
    let id: Int
    let width: Int
    let height: Int
    let url: String
    let image: String
    let duration: Int
    let user: User
    let videoFiles: [VideoFile]
    let videoPictures: [VideoPicture]

    enum CodingKeys: String, CodingKey {
        case id, width, height, url, image, duration, user
        case videoFiles
        case videoPictures
    }
}

// MARK: - User
struct User: Codable {
    let id: Int
    let name: String
    let url: String
}

// MARK: - VideoFile
struct VideoFile: Codable {
    let id: Int
    let quality: String?
    let fileType: String
    let width, height: Int?
    let link: String

    enum CodingKeys: String, CodingKey {
        case id, quality
        case fileType
        case width, height, link
    }
}

// MARK: - VideoPicture
struct VideoPicture: Codable {
    let id: Int
    let picture: String
    let nr: Int
}
