//
//  StockImageServiceProtocol.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import UIKit

protocol StockImageServiceProtocol {
    func fetchImage(urlString: String, completion: @escaping (Result<UIImage?, ImageLoadError>) -> Void)
}
