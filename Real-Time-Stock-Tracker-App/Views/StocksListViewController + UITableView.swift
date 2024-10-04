//
//  StocksListViewController + UITableView.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import UIKit

extension StocksListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.stockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StocksTableViewCell.identifier, for: indexPath) as? StocksTableViewCell else { return UITableViewCell() }
        
        let stock = viewModel.stockList[indexPath.row]
        let stockPrice = viewModel.stockPrices[stock.ticker]
        
        cell.configure(
            with: stock,
            price: stockPrice,
            imageService: viewModel.stockImageService,
            index: indexPath.row
        )
        return cell
    }
}
