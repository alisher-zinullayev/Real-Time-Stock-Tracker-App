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
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        setup()
    }
    
    private func setup() {
        view.addSubview(stocksTableView)
        
        NSLayoutConstraint.activate([
            stocksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stocksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stocksTableView.topAnchor.constraint(equalTo: view.topAnchor),
            stocksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
