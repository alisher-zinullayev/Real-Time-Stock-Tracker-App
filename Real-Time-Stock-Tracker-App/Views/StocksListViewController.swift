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
    
    private lazy var stocksButton: StockActionButton = {
        let button = StockActionButton(type: .stocks)
        button.addTarget(self, action: #selector(stocksButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var favoriteButton: StockActionButton = {
        let button = StockActionButton(type: .favorite)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setBindings()
        setup()
        viewModel.fetchStocks()
    }
    
    private func setBindings() {
        viewModel.reloadTableView = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.stocksTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        
        viewModel.showErrorAlert = { [weak self] errorMessage in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showError(with: errorMessage)
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc private func handleRefresh() {
        viewModel.refreshStocks()
    }
    
    @objc private func stocksButtonTapped() {
        stocksButton.selectButton()
        favoriteButton.deselectButton()
        viewModel.currentState = .all
    }
    
    @objc private func favoriteButtonTapped() {
        stocksButton.deselectButton()
        favoriteButton.selectButton()
        viewModel.currentState = .favorite
    }
}

extension StocksListViewController {
    private func setup() {
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        stocksTableView.refreshControl = refreshControl
        
        view.addSubview(stocksButton)
        view.addSubview(favoriteButton)
        view.addSubview(stocksTableView)
        
        NSLayoutConstraint.activate([
            stocksButton.heightAnchor.constraint(equalToConstant: 32),
            stocksButton.widthAnchor.constraint(equalToConstant: 98),
            stocksButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stocksButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            favoriteButton.heightAnchor.constraint(equalToConstant: 32),
            favoriteButton.leadingAnchor.constraint(equalTo: stocksButton.trailingAnchor, constant: 20),
            favoriteButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            stocksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stocksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stocksTableView.topAnchor.constraint(equalTo: stocksButton.bottomAnchor, constant: 20),
            stocksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func showError(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
