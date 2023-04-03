//
//  Router.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 25.03.2023.
//

import UIKit

protocol SearchRouterDelegate: AnyObject {
    func showError(message: String)
}

final class SearchRouter: SearchRouterDelegate {
    weak var viewController: UIViewController?

    func showError(message: String) {
        let alertController = UIAlertController(title: "Network Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        viewController?.present(alertController, animated: true)
    }
}
