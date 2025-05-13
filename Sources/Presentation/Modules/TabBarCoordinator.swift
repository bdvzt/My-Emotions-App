//
//  TabBarCoordinator.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 01.05.2025.
//

import UIKit

final class TabBarCoordinator: Coordinator {

    var navigationController: UINavigationController
    private let dependencies: AppDependencyContainer
    private var journalCoordinator: JournalListCoordinator?

    init(
        navigationController: UINavigationController,
        dependencies: AppDependencyContainer
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let tabBarController = TabBarController()

        let journalNav = UINavigationController()
        let statisticsNav = UINavigationController()
        let settingsNav = UINavigationController()

        let journalCoordinator = dependencies.makeJournalListCoordinator(navigationController: journalNav)
        self.journalCoordinator = journalCoordinator
        journalCoordinator.start()

        tabBarController.setViewControllers([
            createTabItem(navigationController: journalNav, title: "Журнал", icon: .journal),
            createTabItem(navigationController: UINavigationController(rootViewController: StatisticsViewController()), title: "Статистика", icon: .statistics),
            createTabItem(navigationController: UINavigationController(rootViewController: SettingsViewController()), title: "Настройка", icon: .tools)
        ], animated: false)

        navigationController.setViewControllers([tabBarController], animated: false)
    }

    private func createTabItem(navigationController: UINavigationController, title: String, icon: UIImage?) -> UINavigationController {
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = icon
        return navigationController
    }
}

