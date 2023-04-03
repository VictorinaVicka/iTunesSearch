//
//  Track.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 23.03.2023.
//

import Foundation

struct Track: Codable, Identifiable {
    let id: Int
    let image: URL?
    let title: String?
    let subtitle: String?
    var isFavorite: Bool = false
}

extension Track: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
