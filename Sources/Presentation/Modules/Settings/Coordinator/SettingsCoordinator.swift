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
    private let dependencies: AppDependencyContainer

    init(
        navigationController: UINavigationController,
        settingsViewModel: SettingsViewModel,
        dependencies: AppDependencyContainer
    ) {
        self.navigationController = navigationController
        self.settingsViewModel = settingsViewModel
        self.dependencies = dependencies
    }

    func start() {
        settingsViewModel.delegate = self

        let viewController = SettingsViewController(settingsViewModel: settingsViewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension SettingsCoordinator: SettingsViewModelDelegate {
    func didRequestLogout() {
        let alert = UIAlertController(
            title: "Выход",
            message: "Вы точно хотите выйти из аккаунта?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive) { [weak self] _ in
            self?.logout()
        })

        navigationController.present(alert, animated: true, completion: nil)
    }

    private func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "user_given_name")
        defaults.removeObject(forKey: "user_family_name")
        defaults.removeObject(forKey: "hasSavedUserName")

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = scene.delegate as? SceneDelegate {
            delegate.restartApp()
        }
    }
}
