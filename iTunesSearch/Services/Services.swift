//
//  Services.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 25.03.2023.
//

import Foundation

class Service {
    static let shared = Service()
    private init() { }

    lazy var networkService: NetworkServiceDelegat = {
        NetworkService(urlSession: URLSession.shared)
    }()

    lazy var favoritesStorage: FavoritesStorageDelegat = {
        FavoritesStorage(tracks: StorageData.favoriteTracks)
    }()
}
