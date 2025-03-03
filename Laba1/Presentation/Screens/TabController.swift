//
//  TabController.swift
//  LAB1
//
//  Created by Zayata Budaeva on 20.02.2025.
//

import UIKit

class TabController: UITabBarController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Tab Setup

    private func setup() {
        setupTabs()
    }


    private func setupTabs() {
        let journal = self.createNav(with: "Журнал", and: .journal, vc: JournalViewController())
        let statistics = self.createNav(with: "Статистика", and: .statistics, vc: StatisticsViewController())
        let settings = self.createNav(with: "Настройка", and: .tools, vc: SettingsViewController())

        self.setViewControllers([journal,
                                 statistics,
                                 settings], animated: true)

        self.selectedIndex = 0

        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()

            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .tabBar
            appearance.stackedLayoutAppearance.selected.iconColor = .white
            appearance.stackedLayoutAppearance.normal.iconColor = .tabBarUnselected
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont(name: "VelaSans-Regular", size: 10)!
            ]
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.tabBarUnselected,
                .font: UIFont(name: "VelaSans-Regular", size: 10)!
            ]

            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            self.tabBar.barTintColor = .tabBar
            self.tabBar.tintColor = .white
            self.tabBar.unselectedItemTintColor = .tabBarUnselected
        }
    }

    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)

        nav.tabBarItem.title = title
        nav.tabBarItem.image = image

        return nav
    }
}
