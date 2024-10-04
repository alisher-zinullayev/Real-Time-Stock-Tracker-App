//
//  ViewController.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import UIKit

enum CurrentState {
    case all
    case favorite
    case search
}

final class StocksListViewController: UIViewController {
    var viewModel: StocksViewModel!
    
    private let stocksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(StocksTableViewCell.self, forCellReuseIdentifier: StocksTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stocks"
        view.backgroundColor = .systemBackground
        setViewModel()
        setBindings()
        setup()
        viewModel.fetchStocks()
    }
    
    private func setViewModel() {
        let stockLocalDataSource = StockLocalDataSource()
        let stocksPricesLoader = StockPriceLoader()
        let stockImageLoader = StockImageLoader()
        
        let stockService = StockService(stockLocalDataSource: stockLocalDataSource, stockPricesLoader: stocksPricesLoader)
        let stockImageService = StockImageService(stockImageLoader: stockImageLoader)
        
        viewModel = StocksViewModel(stockService: stockService, stockImageService: stockImageService)
    }
    
    private func setBindings() {
        viewModel.reloadTableView = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.stocksTableView.reloadData()
            }
        }
        
        viewModel.showErrorAlert = { [weak self] errorMessage in
            self?.showError(with: errorMessage)
        }
    }
}

extension StocksListViewController {
    private func setup() {
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        
        view.addSubview(stocksTableView)
        
        NSLayoutConstraint.activate([
            stocksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stocksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stocksTableView.topAnchor.constraint(equalTo: view.topAnchor),
            stocksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func showError(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
