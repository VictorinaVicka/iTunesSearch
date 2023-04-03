//
//  Presenter.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 25.03.2023.
//

import Foundation
import UIKit

protocol SearchPresenterDelegate: AnyObject {
    func presentTrack(track: [Track])
    func showError(_ error: Error)
    func showTracks(result: [ItunesResult])
}

final class SearchPresenter: SearchPresenterDelegate {

    weak var searchViewController: SearchViewController?

    func presentTrack(track: [Track]) {
        searchViewController?.showTracks(model: track)
    }

    func showError(_ error: Error) {
        searchViewController?.showError(message: error.localizedDescription)
    }

    func showTracks(result: [ItunesResult]) {
        if result.isEmpty {
            let alertController = UIAlertController(title: "Nothing found",
                                                    message: "Try another query", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
            searchViewController?.present(alertController, animated: true)
        }
    }
}
