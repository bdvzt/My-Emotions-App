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
    private var settingsCoordinator: SettingsCoordinator?
    private var statisticsCoordinator: StatisticsCoordinator?

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

        let settingsCoordinator = dependencies.makeSettingsCoordinator(navigationController: settingsNav)
        self.settingsCoordinator = settingsCoordinator
        settingsCoordinator.start()

        let stasticsCoordinator = dependencies.makeStatisticsCoordinator(navigationController: statisticsNav)
        self.statisticsCoordinator = stasticsCoordinator
        stasticsCoordinator.start()

        tabBarController.setViewControllers([
            createTabItem(navigationController: journalNav, title: "Журнал", icon: .journal),
            createTabItem(navigationController: statisticsNav, title: "Статистика", icon: .statistics),
            createTabItem(navigationController: settingsNav, title: "Настройка", icon: .tools)
        ], animated: false)

        navigationController.setViewControllers([tabBarController], animated: false)
    }

    private func createTabItem(navigationController: UINavigationController, title: String, icon: UIImage?) -> UINavigationController {
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = icon
        return navigationController
    }
}

