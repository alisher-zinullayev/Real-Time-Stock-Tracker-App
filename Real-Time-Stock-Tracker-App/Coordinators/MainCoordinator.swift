//
//  MainCoordinator.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import UIKit

final class MainCoordinator: Coordinator {
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let stocksViewModel = StocksViewModel()
        stocksViewModel.coordinator = self
        let stocksListViewController = StocksListViewController()
        stocksListViewController.viewModel = stocksViewModel
        navigationController.pushViewController(stocksListViewController, animated: true)
    }
}
