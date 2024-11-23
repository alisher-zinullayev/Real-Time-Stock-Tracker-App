//
//  StocksListViewController + UITableView.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import UIKit

extension StocksListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StocksTableViewCell.identifier, for: indexPath) as? StocksTableViewCell else { return UITableViewCell() }
        
        let cellModel = viewModel.cellModel(for: indexPath)
        cell.configure(with: cellModel, imageService: viewModel.stockImageService)
        
        cell.setFavorite(isFavorite: viewModel.isFavorite(for: cellModel.abbreviation))
        
        cell.favoriteButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.viewModel.toggleFavorite(for: cellModel.abbreviation)
        }
            
        return cell
    }
}
