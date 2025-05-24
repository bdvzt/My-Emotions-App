//
//  StatisticsCoordinator.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 14.05.2025.
//

import UIKit

final class StatisticsCoordinator: Coordinator {
    var navigationController: UINavigationController
    let statisticsViewModel: StatisticsViewModel
    private let dependencies: AppDependencyContainer

    init(
        navigationController: UINavigationController,
        statisticsViewModel: StatisticsViewModel,
        dependencies: AppDependencyContainer
    ) {
        self.navigationController = navigationController
        self.statisticsViewModel = statisticsViewModel
        self.dependencies = dependencies
    }

    func start() {
        let viewController = StatisticsViewController(statisticsViewModel: self.statisticsViewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension StatisticsCoordinator: StatisticsViewModelDelegate {
    
}
