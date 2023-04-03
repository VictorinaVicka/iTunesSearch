//
//  FavoritesStorage.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 26.03.2023.
//

import Foundation

protocol FavoritesStorageDelegat {
    var trackPublisher: Published<[Track]>.Publisher { get }

    func fetch() -> [Track]
    func save(track: Track)
    func remove(track: Track)
}

final class FavoritesStorage: FavoritesStorageDelegat {

    init(tracks: [Track]) {
        self.tracks = tracks
    }

    var trackPublisher: Published<[Track]>.Publisher { $tracks }
    @Published private(set) var tracks: [Track] {
        didSet {
            favoriteSongs = tracks
        }
    }

    @Storage(key: "FavoriteTracks", defaultValue: [])
    private var favoriteSongs: [Track]

    func fetch() -> [Track] {
        StorageData.favoriteTracks
    }

    func save(track: Track) {
        tracks.append(track)
    }

    func remove(track: Track) {
        tracks.removeAll(where: { $0.id == track.id })
    }
}
