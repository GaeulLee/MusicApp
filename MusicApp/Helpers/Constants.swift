//
//  Constants.swift
//  MusicApp
//
//  Created by 이가을 on 3/26/24.
//

import Foundation

public enum MusicApi {
    static let requestUrl = "https://itunes.apple.com/search?"
    static let mediaParam = "media=music"
}

public struct Cell {
    static let musicCellIdentifier = "MusicCell"
    static let musicCollectionViewCellIdentifier = "MusicCollectionViewCell"
    private init() {}
}

//public struct CVCell {
//    static let spacingWitdh: CGFloat = 1
//    static let cellColumns: CGFloat = 3
//    private init() {}
//}
