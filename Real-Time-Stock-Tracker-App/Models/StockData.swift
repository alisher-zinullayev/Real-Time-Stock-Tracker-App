//
//  StockData.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import Foundation

class StockData: Codable {
    var name: String
    var logo: String
    var ticker: String
    var isFavorite: Bool
    
    init(name: String, ticker: String, logo: String, isFavorite: Bool = false) {
        self.name = name
        self.ticker = ticker
        self.logo = logo
        self.isFavorite = isFavorite
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.ticker = try container.decode(String.self, forKey: .ticker)
        self.logo = try container.decode(String.self, forKey: .logo)
        self.isFavorite = false
    }

    static func == (lhs: StockData, rhs: StockData) -> Bool {
        return lhs.ticker == rhs.ticker
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, logo, ticker
    }
}
