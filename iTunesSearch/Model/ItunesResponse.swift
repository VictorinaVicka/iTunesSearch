//
//  ItunesResponse.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 23.03.2023.
//

import Foundation

struct ItunesResponse: Codable {
    let results: [ItunesResult]
}

struct ItunesResult: Codable {
    let trackId: Int
    let artistName: String
    let trackName: String
    let artworkUrl60: String?
}

extension ItunesResult: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(trackId)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.trackId == rhs.trackId
    }
}
