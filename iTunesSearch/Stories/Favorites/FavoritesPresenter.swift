//
//  Presenter.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 25.03.2023.
//

import Foundation

protocol FavoritesPresenterDelegat {
    func presentTracks(track: [Track])
}

final class FavoritesPresenter: FavoritesPresenterDelegat {
    weak var viewController: FavoritesViewControllerDelegate?

    func presentTracks(track: [Track]) {
        viewController?.displayTracks(model: track)
    }
}
