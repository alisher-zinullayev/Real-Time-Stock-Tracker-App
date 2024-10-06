//
//  CurrentState.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 06.10.2024.
//

import Foundation

enum CurrentState {
    case all
    case favorite
    case searchAll(String)
    case searchFavorite(String)
}
