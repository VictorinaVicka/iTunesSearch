//
//  Builder.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 25.03.2023.
//

import Foundation
import UIKit

final class SearchBuilder {
    static func set() -> UIViewController {
        let viewController = SearchViewController()
        let interactor = SearchInteractor(service: Service.shared.networkService,
                                          storage: Service.shared.favoritesStorage)
        viewController.interactor = interactor

        let router = SearchRouter()
        viewController.router = router
        router.viewController = viewController

        let presenter = SearchPresenter()
        presenter.searchViewController = viewController

        interactor.presenter = presenter
        return viewController
    }
}
