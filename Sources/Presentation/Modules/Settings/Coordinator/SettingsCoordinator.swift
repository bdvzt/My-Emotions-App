//
//  SettingsCoordinator.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 13.05.2025.
//

import UIKit

final class SettingsCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let settingsViewModel: SettingsViewModel
    private let dependecies: AppDependencyContainer

    init(
        navigationController: UINavigationController,
        settingsViewModel: SettingsViewModel,
        dependencies: AppDependencyContainer
    ) {
        self.navigationController = navigationController
        self.settingsViewModel = settingsViewModel
        self.dependecies = dependencies
    }

    func start() {
        let viewController = SettingsViewController(
            settingsViewModel: settingsViewModel
        )
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension SettingsCoordinator: SettingsViewModelDelegate {

}
