//
//  TabBarController.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 24.03.2023.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [makeSearch(), makeFavorites()]
    }

    func makeSearch() -> UIViewController {
        let search = SearchBuilder.set()
        let searchNavigation = UINavigationController(rootViewController: search)
        searchNavigation.view.backgroundColor = .white
        searchNavigation.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        return searchNavigation
    }

    func makeFavorites() -> UIViewController {
        let favorites = FavoritesBuilder.set()
        let favoritesNavigation = UINavigationController(rootViewController: favorites)
        favoritesNavigation.view.backgroundColor = .white
        favoritesNavigation.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)

        return favoritesNavigation
    }
}
