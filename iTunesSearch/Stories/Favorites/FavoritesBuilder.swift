//
//  Builder.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 25.03.2023.
//

import Foundation
import UIKit

final class FavoritesBuilder {
    static func set() -> UIViewController {
        let viewController = FavoritesViewController()
        let interactor = FavoritesInteractor(storage: Service.shared.favoritesStorage)
        viewController.interactor = interactor

        let presenter = FavoritesPresenter()
        interactor.presenter = presenter
        presenter.viewController = viewController

        return viewController
    }
}
