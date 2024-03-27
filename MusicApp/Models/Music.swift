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
    let songName: String?
    let artistName: String?
    let albumName: String?
    let previewUrl: String?
    let imageUrl: String?
    private let releaseDate: String?

    // 네트워크에서 주는 이름을 변환 (CodingKey 채택!)
    enum CodingKeys: String, CodingKey {
        case songName = "trackName" // 서버에서 주는 "trackName"을 명시한 케이스(songName)로 바꿔 쓰겠다
        case artistName
        case albumName = "collectionName"
        case previewUrl
        case imageUrl = "artworkUrl100"
        case releaseDate
    }
    
    // (출시 정보에 대한 날짜를 잘 계산하기 위해서) 계산 속성으로
    // "2011-07-05T12:00:00Z" ===> "yyyy-MM-dd"
    var releaseDateString: String? {
        // 서버에서 주는 형태 (ISO규약에 따른 문자열 형태)
        guard let isoDate = ISO8601DateFormatter().date(from: releaseDate ?? "") else {
            return ""
        }
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = myFormatter.string(from: isoDate)
        return dateString
    }
}
