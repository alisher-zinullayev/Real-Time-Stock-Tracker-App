//
//  StocksViewModel.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import Foundation

final class StocksViewModel {
    weak var coordinator: MainCoordinator?
    
    var showErrorAlert: ((String) -> Void)?
    var reloadTableView: (() -> Void)?
    
    var currentState: CurrentState = .all {
        didSet {
            reloadTableView?()
        }
    }
    
    var currentSearchQuery: String?
    
    private let stockService: StockServiceProtocol
    let stockImageService: StockImageServiceProtocol
    private let stocksRepository: StocksRepositoryProtocol
    private let model: StocksModel
    
    init(stockService: StockServiceProtocol,
         stockImageService: StockImageServiceProtocol,
         stocksRepository: StocksRepositoryProtocol) {
        self.stockService = stockService
        self.stockImageService = stockImageService
        self.stocksRepository = stocksRepository
        self.model = StocksModel(stocksRepository: stocksRepository)
    }
    
    func fetchStocks() {
        model.fetchStocks(stockService: stockService) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                self.fetchStockPrices()
            case .failure(let error):
                self.showErrorAlert?("Failed to fetch stocks: \(error.localizedDescription)")
            }
        }
    }
    
    func refreshStocks() {
        fetchStocks()
    }
    
    func fetchStockPrices() {
        model.fetchStockPrices(stockService: stockService) { [weak self] in
            self?.reloadTableView?()
        }
    }
    
    func isFavorite(for ticker: String) -> Bool {
        return model.isFavorite(ticker)
    }

    func toggleFavorite(for ticker: String) {
        model.toggleFavorite(for: ticker, stockService: stockService) { [weak self] in
            self?.reloadTableView?()
        }
    }
    
    func filterStocks(with query: String) {
        currentSearchQuery = query
        model.filterStocks(with: query, currentState: &currentState)
        reloadTableView?()
    }
    
    func resetSearch() {
        model.resetSearch(currentState: &currentState)
        currentSearchQuery = nil
        reloadTableView?()
    }
    
    func cellModel(for indexPath: IndexPath) -> StocksTableViewCell.Model {
        return model.cellModel(for: indexPath, currentState: currentState)
    }
    
    func numberOfRows() -> Int {
        switch currentState {
        case .all, .searchAll:
            return model.filteredStocks.isEmpty ? model.allStocks.count : model.filteredStocks.count
        case .favorite, .searchFavorite:
            return model.filteredStocks.isEmpty ? model.favoriteStocks.count : model.filteredStocks.count
        }
    }
}

