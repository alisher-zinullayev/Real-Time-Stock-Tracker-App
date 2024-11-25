//
//  StockImageLoaderProtocol.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import UIKit

protocol StockImageLoaderProtocol {
    func fetchImage(urlString: String) async throws -> UIImage?
}
