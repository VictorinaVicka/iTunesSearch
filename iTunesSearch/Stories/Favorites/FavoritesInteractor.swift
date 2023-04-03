//
//  Interactor.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 25.03.2023.
//

import Combine
import UIKit

protocol FavoritesInteractorDelegat {
    func fetchTracks()
    func selectFavorites(track: Track)
}

final class FavoritesInteractor {
    var presenter: FavoritesPresenterDelegat?

    private var cancellables: Set<AnyCancellable> = []
    private let favoritesStorage: FavoritesStorageDelegat
    private var tracks: [Track] = [] {
        didSet {
            presenter?.presentTracks(track: tracks)
        }
    }

    init(storage: FavoritesStorageDelegat) {
        self.favoritesStorage = storage
        followFavoriteTracks()
    }

    private func followFavoriteTracks() {
        favoritesStorage.trackPublisher
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                    self?.tracks.removeAll()
                }
            }, receiveValue: { [weak self] tracks in
                self?.tracks = tracks
            }).store(in: &cancellables)
    }
}

// MARK: FavoritesInteractorDelegat
extension FavoritesInteractor: FavoritesInteractorDelegat {
    func fetchTracks() {
        tracks = favoritesStorage.fetch()
    }

    func selectFavorites(track: Track) {
        var updatedTrack = track
        updatedTrack.isFavorite = !track.isFavorite

        if updatedTrack.isFavorite {
            favoritesStorage.save(track: updatedTrack)
        } else {
            favoritesStorage.remove(track: updatedTrack)
        }
    }
}
