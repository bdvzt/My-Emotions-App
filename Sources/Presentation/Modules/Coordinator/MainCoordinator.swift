//
//  MainCoordinator.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 01.05.2025.
//

import UIKit

class MainCoordinator: Coordinator {

    private let isLoggedIn: Bool = false // TODO: - логика проверка логина

    let navigationController: UINavigationController
    let dependencies: AppDependencyContainer

    private var tabBarCoordinator: TabBarCoordinator?

    init(
        navigationController: UINavigationController,
        dependencies: AppDependencyContainer
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        if isLoggedIn {
            showMainApp()
        } else {
            showLogin()
        }
    }

    private func showLogin() {
        let loginViewModel = dependencies.makeLoginViewModel()
        loginViewModel.delegate = self

        let loginViewController = LoginViewController(loginViewModel: loginViewModel)
        navigationController.pushViewController(loginViewController, animated: false) // TODO: push/set
    }

    private func showMainApp() {
        let tabBarCoordinator = dependencies
            .makeTabBarCoordinator(navigationController: navigationController)
        self.tabBarCoordinator = tabBarCoordinator
        tabBarCoordinator.start()
    }
}

extension MainCoordinator: LoginViewModelDelegate {
    func didLogin() {
        showMainApp()
    }
}
