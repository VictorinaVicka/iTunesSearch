//
//  ViewController.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 24.03.2023.
//

import Combine
import SnapKit
import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func showTracks(model: [Track])
    func showError(message: String)
}

final class SearchViewController: UIViewController {
    var interactor: SearchInteractorDelegate?
    var router: SearchRouterDelegate?
    private let trackListViewController = TrackListViewController()

    private(set) lazy var searchController: UISearchController = {
        var controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.searchBar.autocorrectionType = .no
        controller.searchBar.placeholder = "Search"
        controller.hidesNavigationBarDuringPresentation = false
        return controller
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Type artist to quarry songs"
        label.font = .systemFont(ofSize: 20)
        return label
    }()

    // MARK: - Life cycle
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: - Private
    private func setup() {
        let interactor = SearchInteractor(service: Service.shared.networkService,
                                          storage: Service.shared.favoritesStorage)
        self.interactor = interactor

        let router = SearchRouter()
        router.viewController = self
        self.router = router

        let presenter = SearchPresenter()
        presenter.searchViewController = self
        interactor.presenter = presenter
    }

    private func configure() {
        trackListViewController.delegate = self

        trackListViewController.view.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(trackListViewController.view)
        view.addSubview(emptyLabel)

        trackListViewController.view.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(150)
            make.bottom.equalTo(view).offset(-100)
        }

        emptyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
        }

        emptyLabel.isHidden = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.count != 0 {
            emptyLabel.isHidden = true
        } else {
            emptyLabel.isHidden = false
        }
        interactor?.updateSearch(text: searchText)
    }
}

// MARK: - SearchViewControllerDelegate
extension SearchViewController: SearchViewControllerDelegate {
    func showTracks(model: [Track]) {
        self.trackListViewController.updateTracks(tracks: model)
    }

    func showError(message: String) {
        router?.showError(message: message)
    }
}

// MARK: - TrackListViewControllerDelegate
extension SearchViewController: TrackListViewControllerDelegate {
    func chooseFavorite(track: Track) {
        interactor?.selectFavorite(track: track)
    }
}
