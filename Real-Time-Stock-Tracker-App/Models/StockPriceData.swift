//
//  StockPriceData.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import Foundation

struct StockPriceData: Codable {
    let currentPrice: Double?
    let changePercent: Double?
    let change: Double?

    enum CodingKeys: String, CodingKey {
        case currentPrice = "c"
        case changePercent = "dp"
        case change = "d"
    }
}
