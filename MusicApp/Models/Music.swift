//
//  Music.swift
//  MusicApp
//
//  Created by 이가을 on 3/26/24.
//

import Foundation

// MARK: - MusicData
struct MusicData: Codable {
    let resultCount: Int
    let results: [Music]
}

// MARK: - Music
struct Music: Codable {
    let songName: String
    let artistName: String
    let albumName: String
    let previewUrl: String
    let imageUrl: String
    private let releaseDate: Date

    // 네트워크에서 주는 이름을 변환 (CodingKey 채택!)
    enum CodingKeys: String, CodingKey {
        case songName = "trackName" // 서버에서 주는 "trackName"을 명시한 케이스(songName)로 바꿔 쓰겠다
        case artistName
        case albumName = "collectionName"
        case previewUrl
        case imageUrl = "artworkUrl100"
        case releaseDate
    }
}
