//
//  AppCoordinator.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showMainFlow()
    }
    
    private func showMainFlow() {
        let mainCoordinator = MainCoordinator.create(navigationController: navigationController)
        mainCoordinator.parentCoordinator = self
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        if let child = child {
            childCoordinators = childCoordinators.filter { $0 !== child }
        }
    }
}
