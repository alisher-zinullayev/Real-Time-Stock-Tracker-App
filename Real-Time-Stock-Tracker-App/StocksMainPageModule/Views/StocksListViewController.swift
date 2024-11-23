//
//  ViewController.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import UIKit

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
    
    private let stocksSearchBar: StocksSearchBar = {
        let searchBar = StocksSearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
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
    
    private var currentSearchQuery: String? {
        return viewModel.currentSearchQuery
    }
    
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
        if case .searchFavorite(_) = viewModel.currentState, let query = currentSearchQuery {
            viewModel.currentState = .searchAll(query)
        } else {
            viewModel.currentState = .all
        }
    }
    
    @objc private func favoriteButtonTapped() {
        stocksButton.deselectButton()
        favoriteButton.selectButton()
        if case .searchAll(_) = viewModel.currentState, let query = currentSearchQuery {
            viewModel.currentState = .searchFavorite(query)
        } else {
            viewModel.currentState = .favorite
        }
    }
}

extension StocksListViewController {
    private func setup() {
        stocksSearchBar.delegate = self
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        stocksTableView.refreshControl = refreshControl
        
        view.addSubview(stocksSearchBar)
        view.addSubview(stocksButton)
        view.addSubview(favoriteButton)
        view.addSubview(stocksTableView)
        
        NSLayoutConstraint.activate([
            stocksSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stocksSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stocksSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stocksSearchBar.heightAnchor.constraint(equalToConstant: 48),
            
            stocksButton.heightAnchor.constraint(equalToConstant: 32),
            stocksButton.widthAnchor.constraint(equalToConstant: 98),
            stocksButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stocksButton.topAnchor.constraint(equalTo: stocksSearchBar.bottomAnchor, constant: 20),
            
            favoriteButton.heightAnchor.constraint(equalToConstant: 32),
            favoriteButton.leadingAnchor.constraint(equalTo: stocksButton.trailingAnchor, constant: 20),
            favoriteButton.topAnchor.constraint(equalTo: stocksSearchBar.bottomAnchor, constant: 20),
            
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

extension StocksListViewController: StocksSearchBarDelegate {
    func customSearchBar(_ searchBar: StocksSearchBar, didChangeSearchText searchText: String) {
        viewModel.filterStocks(with: searchText)
    }
    
    func customSearchBarDidSwitchToSearchResults(_ searchBar: StocksSearchBar) {
        
    }
    
    func customSearchBarDidReturnToNormal(_ searchBar: StocksSearchBar) {
        viewModel.resetSearch()
    }
}
