//
//  StocksTableViewCell.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import UIKit

final class StocksTableViewCell: UITableViewCell {
    static let identifier = String(describing: StocksTableViewCell.self)
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(index: Int) {
        if isEven(index) {
            containerView.layer.backgroundColor = UIColor.myGrayColor.cgColor
        } else {
            containerView.layer.backgroundColor = UIColor.myWhiteColor.cgColor
        }
    }
}

extension StocksTableViewCell {
    private func setupUI() {
        name.setContentHuggingPriority(.defaultLow, for: .horizontal)
        name.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        currentPrice.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        currentPrice.setContentCompressionResistancePriority(.required, for: .horizontal)
        percentPrice.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        percentPrice.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        self.addSubview(containerView)
        containerView.addSubview(containerForegroundView)
        containerView.addSubview(logo)
        containerView.addSubview(name)
        containerView.addSubview(abbreviation)
        containerView.addSubview(currentPrice)
        containerView.addSubview(percentPrice)
        containerView.addSubview(favoriteImage)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 68),
            
            logo.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            logo.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            logo.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            logo.widthAnchor.constraint(equalToConstant: 52),
            logo.heightAnchor.constraint(equalToConstant: 52),
            
            name.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 12),
            name.trailingAnchor.constraint(lessThanOrEqualTo: currentPrice.leadingAnchor, constant: -8),
            name.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            
            favoriteImage.leadingAnchor.constraint(equalTo: name.trailingAnchor, constant: 6),
            favoriteImage.centerYAnchor.constraint(equalTo: name.centerYAnchor),
            favoriteImage.widthAnchor.constraint(equalToConstant: 16),
            favoriteImage.heightAnchor.constraint(equalToConstant: 16),
            favoriteImage.trailingAnchor.constraint(lessThanOrEqualTo: currentPrice.leadingAnchor, constant: -8),
            
            currentPrice.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -17),
            currentPrice.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            currentPrice.leadingAnchor.constraint(greaterThanOrEqualTo: favoriteImage.trailingAnchor, constant: 8),
            
            abbreviation.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 12),
            abbreviation.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4),
            abbreviation.trailingAnchor.constraint(lessThanOrEqualTo: percentPrice.leadingAnchor, constant: -8),
            
            percentPrice.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -17),
            percentPrice.topAnchor.constraint(equalTo: currentPrice.bottomAnchor, constant: 4),
            percentPrice.leadingAnchor.constraint(greaterThanOrEqualTo: abbreviation.trailingAnchor, constant: 8),
            percentPrice.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14)
        ])
    }
}
