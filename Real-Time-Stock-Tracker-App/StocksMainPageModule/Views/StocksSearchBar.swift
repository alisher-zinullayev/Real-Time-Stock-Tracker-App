//
//  StocksSearchBar.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 06.10.2024.
//

import UIKit

protocol StocksSearchBarDelegate: AnyObject {
    func customSearchBar(_ searchBar: StocksSearchBar, didChangeSearchText searchText: String)
    func customSearchBarDidSwitchToSearchResults(_ searchBar: StocksSearchBar)
    func customSearchBarDidReturnToNormal(_ searchBar: StocksSearchBar)
}

final class StocksSearchBar: UIView {
    weak var delegate: StocksSearchBarDelegate?
    
    private var state: SearchBarState = .normal
    
    private lazy var searchBar: UITextField = {
        let searchBar = UITextField()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.placeholder = "Find company or ticker"
        if let placeholder = searchBar.placeholder {
            let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
                .font: UIFont.systemFont(ofSize: 16.0, weight: .semibold),
                .foregroundColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
            ])
            searchBar.attributedPlaceholder = attributedPlaceholder
        }
        searchBar.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return searchBar
    }()
    
    private let leftImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "search")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let rightImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "cancel")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let containerForegroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        searchBar.delegate = self
        setupUI()
        setupTapGesture()
        updateSearchBarImages(forState: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTapGesture() {
        let tapGestureLeftImage = UITapGestureRecognizer(target: self, action: #selector(leftImageTapped))
        leftImage.isUserInteractionEnabled = true
        leftImage.addGestureRecognizer(tapGestureLeftImage)
        
        let tapGestureRightImage = UITapGestureRecognizer(target: self, action: #selector(rightImageTapped))
        rightImage.isUserInteractionEnabled = true
        rightImage.addGestureRecognizer(tapGestureRightImage)
    }
    
    @objc private func leftImageTapped() {
        switch state {
        case .normal:
            searchBar.becomeFirstResponder()
        case .focus, .filled:
            searchBar.text = ""
            searchBar.resignFirstResponder()
            state = .normal
            delegate?.customSearchBarDidReturnToNormal(self)
            updateSearchBarImages(forState: .normal)
        }
    }
    
    @objc func rightImageTapped() {
        guard state == .filled else { return }
        searchBar.text = ""
        delegate?.customSearchBar(self, didChangeSearchText: "")
        state = .focus
        delegate?.customSearchBarDidSwitchToSearchResults(self)
        updateSearchBarImages(forState: .focus)
        searchBar.resignFirstResponder()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.isEmpty {
            if state != .focus {
                state = .focus
                delegate?.customSearchBarDidSwitchToSearchResults(self)
                updateSearchBarImages(forState: .focus)
            }
        } else {
            if state != .filled {
                state = .filled
                delegate?.customSearchBarDidSwitchToSearchResults(self)
            }
            delegate?.customSearchBar(self, didChangeSearchText: text)
            updateSearchBarImages(forState: .filled)
        }
    }
    
    private func updateSearchBarImages(forState state: SearchBarState) {
        switch state {
        case .normal:
            leftImage.isHidden = false
            rightImage.isHidden = true
            leftImage.image = UIImage(named: "search")
        case .focus:
            leftImage.isHidden = false
            rightImage.isHidden = true
            leftImage.image = UIImage(named: "back")
        case .filled:
            leftImage.isHidden = false
            rightImage.isHidden = false
            leftImage.image = UIImage(named: "back")
            rightImage.image = UIImage(named: "cancel")
        }
    }
    
    private func setupUI() {
        addSubview(containerView)
        addSubview(containerForegroundView)
        addSubview(searchBar)
        addSubview(leftImage)
        addSubview(rightImage)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerForegroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            containerForegroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            containerForegroundView.topAnchor.constraint(equalTo: containerView.topAnchor),
            containerForegroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            leftImage.leadingAnchor.constraint(equalTo: containerForegroundView.leadingAnchor, constant: 16),
            leftImage.topAnchor.constraint(equalTo: containerForegroundView.topAnchor, constant: 12),
            leftImage.bottomAnchor.constraint(equalTo: containerForegroundView.bottomAnchor, constant: -12),
            leftImage.heightAnchor.constraint(equalToConstant: 24),
            leftImage.widthAnchor.constraint(equalToConstant: 24),
            
            searchBar.leadingAnchor.constraint(equalTo: leftImage.trailingAnchor, constant: 8),
            searchBar.topAnchor.constraint(equalTo: containerForegroundView.topAnchor, constant: 12),
            searchBar.bottomAnchor.constraint(equalTo: containerForegroundView.bottomAnchor, constant: -12),
            searchBar.trailingAnchor.constraint(equalTo: rightImage.leadingAnchor, constant: 8),
            
            rightImage.trailingAnchor.constraint(equalTo: containerForegroundView.trailingAnchor, constant: -16),
            rightImage.topAnchor.constraint(equalTo: containerForegroundView.topAnchor, constant: 12),
            rightImage.bottomAnchor.constraint(equalTo: containerForegroundView.bottomAnchor, constant: -12),
            rightImage.heightAnchor.constraint(equalToConstant: 24),
            rightImage.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}

extension StocksSearchBar: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch state {
        case .normal:
            state = .focus
            delegate?.customSearchBarDidSwitchToSearchResults(self)
            updateSearchBarImages(forState: .focus)
        case .focus, .filled:
            break
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.isEmpty {
            if state != .focus {
                state = .focus
                delegate?.customSearchBarDidSwitchToSearchResults(self)
                updateSearchBarImages(forState: .focus)
            }
        } else {
            if state != .filled {
                state = .filled
                delegate?.customSearchBarDidSwitchToSearchResults(self)
                delegate?.customSearchBar(self, didChangeSearchText: text)
                updateSearchBarImages(forState: .filled)
            } else {
                delegate?.customSearchBar(self, didChangeSearchText: text)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            state = .normal
            delegate?.customSearchBarDidReturnToNormal(self)
            updateSearchBarImages(forState: .normal)
        } else {
            state = .filled
            updateSearchBarImages(forState: .filled)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
