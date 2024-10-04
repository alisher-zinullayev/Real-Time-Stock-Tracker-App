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
    
    private let stockService: StockServiceProtocol
    private let stockImageService: StockImageServiceProtocol

    init(navigationController: UINavigationController,
         stockService: StockServiceProtocol,
         stockImageService: StockImageServiceProtocol) {
        self.navigationController = navigationController
        self.stockService = stockService
        self.stockImageService = stockImageService
    }
    
    func start() {
        let stocksViewModel = StocksViewModel(stockService: stockService, stockImageService: stockImageService)
        stocksViewModel.coordinator = self
        let stocksListViewController = StocksListViewController()
        stocksListViewController.viewModel = stocksViewModel
        navigationController.pushViewController(stocksListViewController, animated: true)
    }
    
    static func create(navigationController: UINavigationController) -> MainCoordinator {
        let stockLocalDataSource = StockLocalDataSource()
        let stocksPricesLoader = StockPriceLoader()
        let stockImageLoader = StockImageLoader()
        
        let stockService = StockService(stockLocalDataSource: stockLocalDataSource,
                                        stockPricesLoader: stocksPricesLoader)
        let stockImageService = StockImageService(stockImageLoader: stockImageLoader)
        
        return MainCoordinator(navigationController: navigationController,
                               stockService: stockService,
                               stockImageService: stockImageService)
    }
}
