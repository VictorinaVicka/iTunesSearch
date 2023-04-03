//
//  Interactor.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 25.03.2023.
//

import UIKit
import Combine

protocol SearchInteractorDelegate: AnyObject {
    func updateSearch(text: String)
    func selectFavorite(track: Track)
}

final class SearchInteractor: SearchInteractorDelegate {
    var presenter: SearchPresenterDelegate?

    @Published private var searchText = ""
    private let service: NetworkServiceDelegat
    private let storage: FavoritesStorageDelegat
    private var cancellables: Set<AnyCancellable> = []

    private var tracks: [ItunesResult] = [] {
        didSet {
            updateTracks()
        }
    }

    private var favorites: [Track] = [] {
        didSet {
            updateTracks()
        }
    }

    init(service: NetworkServiceDelegat,
         storage: FavoritesStorageDelegat) {
        self.service = service
        self.storage = storage

        followText()
    }

    // MARK: - Public
    func updateSearch(text: String) {
        searchText = text
    }

    func selectFavorite(track: Track) {
        var updatedTrack = track
        updatedTrack.isFavorite = !track.isFavorite
        if updatedTrack.isFavorite {
            storage.save(track: updatedTrack)
        } else {
            storage.remove(track: updatedTrack)
        }
    }

    // MARK: - Private
    private func followText() {
        $searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] request in
                if request.isEmpty {
                    self?.tracks.removeAll()
                } else {
                    self?.requestSearch(query: request)
                }
            }.store(in: &cancellables)

        storage.trackPublisher
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                    self?.favorites.removeAll()
                    self?.presenter?.showError(error)
                }
            }, receiveValue: { [weak self] tracks in
                self?.favorites = tracks
            }).store(in: &cancellables)
    }

    private func updateTracks() {
        let tracks = tracks.map({
            Track(
                id: $0.trackId,
                image: URL(string: $0.artworkUrl60 ?? ""),
                title: $0.trackName,
                subtitle: $0.artistName,
                isFavorite: self.isFavorite(id: $0.trackId)
            )
        })
        presenter?.presentTrack(track: tracks)
    }

    private func requestSearch(query: String) {
        let component = Component(host: "itunes.apple.com",
                                path: "/search",
                                headers: [:],
                                queryItems:
                                    [URLQueryItem(name: "term", value: query),
                                     URLQueryItem(name: "media", value: "music")])

        service.request(component: component)
            .receive(on: DispatchQueue.main)
            .decode(type: ItunesResponse.self, decoder: JSONDecoder())
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                    self?.tracks.removeAll()
                    self?.presenter?.showError(error)
                }
            } receiveValue: { [weak self] response in
                print("response", response)
                self?.tracks = response.results
            }.store(in: &cancellables)
    }

    private func isFavorite(id: Int) -> Bool {
        favorites.contains(where: { $0.id == id })
    }
}
