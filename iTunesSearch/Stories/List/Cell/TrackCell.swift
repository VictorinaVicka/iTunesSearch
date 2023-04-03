//
//  TrackCell.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 25.03.2023.
//

import Kingfisher
import SnapKit
import UIKit

final class TrackCell: UICollectionViewCell {
    var selection: (() -> Void)?

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private lazy var favoriteButton: UIButton = {
        var button = UIButton()
        button.addTarget(self, action: #selector(self.favoriteTapped), for: .touchUpInside)
        return button
    }()

    private var isFavorite = false {
        didSet {
            let image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            favoriteButton.setImage(image, for: .normal)
        }
    }

    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
        setupConstraints()
        self.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isFavorite = false
    }

    // MARK: - Public
    func set(from content: Track) {
        titleLabel.text = content.title
        subtitleLabel.text = content.subtitle
        isFavorite = content.isFavorite
        loadImage(url: content.image)
    }

    // MARK: - Private
    private func setupElements() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        imageView.contentMode = .scaleToFill

        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 1

        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.numberOfLines = 1
    }

    private func setupConstraints() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(favoriteButton)

        imageView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView)
            make.height.width.equalTo(50)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.right.equalTo(favoriteButton).offset(-30)
            make.left.equalTo(imageView).offset(60)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(20)
            make.left.equalTo(imageView).offset(60)
            make.right.equalTo(favoriteButton).offset(-30)
        }

        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-16)
        }
    }

    private func loadImage(url: URL?) {
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
        imageView.kf.setImage(with: url,
                              placeholder: nil,
                              options: [
                                .processor(processor),
                                .scaleFactor(UIScreen.main.scale),
                                .transition(.fade(1)),
                                .cacheOriginalImage
                              ],
                              completionHandler: nil)

    }

    @objc private func favoriteTapped() {
        isFavorite = !isFavorite
        if let selection = selection {
            selection()
        }
    }
}
