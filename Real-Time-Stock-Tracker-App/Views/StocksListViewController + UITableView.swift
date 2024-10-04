//
//  StocksListViewController + UITableView.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import UIKit

extension StocksListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.currentState {
        case .all:
            viewModel.allStocks.count
        case .favorite:
            viewModel.favoriteStocks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StocksTableViewCell.identifier, for: indexPath) as? StocksTableViewCell else { return UITableViewCell() }
        
        let stock: StockData
        
        switch viewModel.currentState {
        case .all:
            stock = viewModel.allStocks[indexPath.row]
        case .favorite:
            stock = viewModel.favoriteStocks[indexPath.row]
        }
        
        let stockPrice = viewModel.stockPrices[stock.ticker]
        
        cell.configure(
            with: stock,
            price: stockPrice,
            imageService: viewModel.stockImageService,
            index: indexPath.row
        )
        
        cell.setFavorite(isFavorite: viewModel.isFavorite(stock))
        
        cell.favoriteButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.viewModel.toggleFavorite(for: stock)
        }
        
        return cell
    }
}
