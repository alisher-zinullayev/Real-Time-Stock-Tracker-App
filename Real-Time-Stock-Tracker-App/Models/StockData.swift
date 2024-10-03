//
//  StockData.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import Foundation

class StockData: Codable {
    let name: String
    let logo: String
    let ticker: String
    var isFavorite: Bool

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
