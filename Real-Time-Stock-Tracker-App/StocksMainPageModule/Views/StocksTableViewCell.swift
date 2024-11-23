//
//  StocksTableViewCell.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import UIKit

final class StocksTableViewCell: UITableViewCell {
    static let identifier = String(describing: StocksTableViewCell.self)
    
    var favoriteButtonTapped: (() -> Void)?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let containerForegroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "YandexLogo")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "YNDX"
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let abbreviation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Yandex, LLC"
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    private let favoriteImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "NotFavorite")
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = UIColor(cgColor: CGColor(red: 1, green: 0.79, blue: 0.11, alpha: 1))
        return imageView
    }()
    
    private let currentPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "4 764,6 ₽"
        label.textAlignment = .right
        return label
    }()
    
    private let percentPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.14, green: 0.7, blue: 0.364, alpha: 1)
        label.text = "+55 ₽ (1,15%)"
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupFavoriteTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupFavoriteTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteImageTapped))
        favoriteImage.isUserInteractionEnabled = true
        favoriteImage.addGestureRecognizer(tapGesture)
    }
    
    @objc private func favoriteImageTapped() {
        favoriteButtonTapped?()
    }
    
    func configure(
        with stock: StockData,
        price: StockPriceData?,
        imageService: StockImageServiceProtocol,
        index: Int
    ) {
        name.text = stock.name
        abbreviation.text = stock.ticker
        
        imageService.fetchImage(urlString: stock.logo) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.logo.image = image
                }
            case .failure(let error):
                print("failed to load image for \(stock.ticker): \(error.localizedDescription)")
            }
        }
        
        if let price = price {
            if let newPrice = price.currentPrice {
                currentPrice.text = String(format: "$%.2f", newPrice)
            } else {
                currentPrice.text = "--"
            }
            if let change = price.change, let changePercent = price.changePercent {
                percentPrice.text = String(format: "%+.2f (%.2f%%)", change, changePercent)
                percentPrice.textColor = change >= 0 ? .systemGreen : .systemRed
            } else {
                percentPrice.text = "--"
            }
        } else {
            currentPrice.text = "--"
            percentPrice.text = "--"
        }
        
        switch stock.isFavorite {
        case true:
            favoriteImage.image = UIImage(named: "Favorite")
        case false:
            favoriteImage.image = UIImage(named: "NotFavorite")
        }
        
        switch isEven(index) {
        case true:
            containerView.layer.backgroundColor = UIColor.myGrayColor.cgColor
        case false:
            containerView.layer.backgroundColor = UIColor.myWhiteColor.cgColor
        }
        
        setFavorite(isFavorite: stock.isFavorite)
    }
    
    func setFavorite(isFavorite: Bool) {
        let imageName = isFavorite ? "Favorite" : "NotFavorite"
        favoriteImage.image = UIImage(named: imageName)
        favoriteImage.tintColor = isFavorite ? .systemRed : UIColor(cgColor: CGColor(red: 1, green: 0.79, blue: 0.11, alpha: 1))
    }
}

extension StocksTableViewCell {
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(containerForegroundView)
        containerView.addSubview(logo)
        containerView.addSubview(name)
        containerView.addSubview(abbreviation)
        containerView.addSubview(currentPrice)
        containerView.addSubview(percentPrice)
        containerView.addSubview(favoriteImage)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 68),
            
            containerForegroundView.topAnchor.constraint(equalTo: containerView.topAnchor),
            containerForegroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            containerForegroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            containerForegroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            containerForegroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: 68),
            
            logo.heightAnchor.constraint(equalToConstant: 52),
            logo.widthAnchor.constraint(equalToConstant: 52),
            logo.leadingAnchor.constraint(equalTo: containerForegroundView.leadingAnchor, constant: 8),
            logo.topAnchor.constraint(equalTo: containerForegroundView.topAnchor, constant: 8),
            logo.bottomAnchor.constraint(lessThanOrEqualTo: containerForegroundView.bottomAnchor, constant: -8),
            
            name.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 12),
            name.topAnchor.constraint(equalTo: containerForegroundView.topAnchor, constant: 14),
            name.bottomAnchor.constraint(equalTo: containerForegroundView.bottomAnchor, constant: -30),
            
            abbreviation.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 12),
            abbreviation.bottomAnchor.constraint(equalTo: containerForegroundView.bottomAnchor, constant: -14),
            abbreviation.topAnchor.constraint(equalTo: containerForegroundView.topAnchor, constant: 38),
            
            favoriteImage.leadingAnchor.constraint(equalTo: name.trailingAnchor, constant: 6),
            favoriteImage.topAnchor.constraint(equalTo: name.topAnchor),
            favoriteImage.bottomAnchor.constraint(equalTo: name.bottomAnchor),
            
            currentPrice.trailingAnchor.constraint(equalTo: containerForegroundView.trailingAnchor, constant: -17),
            currentPrice.topAnchor.constraint(equalTo: containerForegroundView.topAnchor, constant: 14),
            currentPrice.bottomAnchor.constraint(equalTo: containerForegroundView.bottomAnchor, constant: -30),
            
            percentPrice.trailingAnchor.constraint(equalTo: containerForegroundView.trailingAnchor, constant: -12),
            percentPrice.topAnchor.constraint(equalTo: containerForegroundView.topAnchor, constant: 38),
            percentPrice.bottomAnchor.constraint(equalTo: containerForegroundView.bottomAnchor, constant: -12),
        ])
    }
}
