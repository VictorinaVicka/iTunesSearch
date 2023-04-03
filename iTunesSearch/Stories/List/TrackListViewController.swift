//
//  SongListCollectionViewController.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 25.03.2023.
//

import SnapKit
import UIKit

protocol TrackListViewControllerDelegate: AnyObject {
    func chooseFavorite(track: Track)
}

final class TrackListViewController: UIViewController {
    private enum Constants {
        static let cellId = "TrackCell"
    }

    weak var delegate: TrackListViewControllerDelegate?
    private var tracks: [Track] = []

    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 70)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.keyboardDismissMode = .none
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: Constants.cellId)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        set()
    }

    func updateTracks(tracks: [Track]) {
        self.tracks = tracks
        collectionView.reloadData()
    }

    private func set() {
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(view)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension TrackListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellId, for: indexPath)
        guard let cell = cell as? TrackCell else { return cell }

        let item = tracks[indexPath.item]
        cell.set(from: item)

        cell.selection = { [weak self] in
            self?.delegate?.chooseFavorite(track: item)
        }

        return cell
    }
}
