//
//  StockActionButton.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import UIKit

class StockActionButton: UIButton {
    enum ButtonType {
        case stocks
        case favorite
    }
    
    init(type: ButtonType) {
        super.init(frame: .zero)
        setupButton(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(type: ButtonType) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        switch type {
        case .stocks:
            self.setTitle("Stocks", for: .normal)
            self.setTitleColor(.black, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        case .favorite:
            self.setTitle("Favorite", for: .normal)
            self.setTitleColor(.gray, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        }
    }
    
    func selectButton() {
        self.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        self.setTitleColor(.black, for: .normal)
    }
    
    func deselectButton() {
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.setTitleColor(.gray, for: .normal)
    }
}
