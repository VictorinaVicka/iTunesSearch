//
//  ViewController.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 25.03.2023.
//

import Combine
import SnapKit
import UIKit

protocol FavoritesViewControllerDelegate: AnyObject {
    func displayTracks(model: [Track])
}

final class FavoritesViewController: UIViewController {
    var interactor: FavoritesInteractorDelegat?
    private let trackListViewController = TrackListViewController()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Click 💙 to add songs"
        label.font = .systemFont(ofSize: 20)
        return label
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourites"
        configure()
        interactor?.fetchTracks()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Private
    private func setup() {
        let interactor = FavoritesInteractor(storage: Service.shared.favoritesStorage)
        let presenter = FavoritesPresenter()
        self.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = self
    }

    private func configure() {
        trackListViewController.delegate = self

        trackListViewController.view.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(trackListViewController.view)
        view.addSubview(emptyLabel)

        emptyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
        }

        trackListViewController.view.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(150)
            make.bottom.equalTo(view).offset(-100)
        }

        emptyLabel.isHidden = false
    }
}

// MARK: - FavoritesViewControllerDelegate
extension FavoritesViewController: FavoritesViewControllerDelegate {
    func displayTracks(model: [Track]) {
        if !model.isEmpty {
            emptyLabel.isHidden = true
        } else {
            emptyLabel.isHidden = false
        }
        trackListViewController.updateTracks(tracks: model)
    }
}

// MARK: - TrackListViewControllerDelegate
extension FavoritesViewController: TrackListViewControllerDelegate {
    func chooseFavorite(track: Track) {
        interactor?.selectFavorites(track: track)
    }
}
