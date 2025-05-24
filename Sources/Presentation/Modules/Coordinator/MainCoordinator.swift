//
//  MainCoordinator.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 01.05.2025.
//

import UIKit
import SafariServices
import LocalAuthentication

class MainCoordinator: NSObject, Coordinator {

    private var isLoggedIn: Bool {
        let hasName = UserDefaults.standard.string(forKey: "user_given_name") != nil
        let hasSurname = UserDefaults.standard.string(forKey: "user_family_name") != nil
        return hasName && hasSurname
    }

    let navigationController: UINavigationController
    let dependencies: AppDependencyContainer

    private var tabBarCoordinator: TabBarCoordinator?

    init(navigationController: UINavigationController,
         dependencies: AppDependencyContainer
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        if isLoggedIn {
            if dependencies.settingsRepository.isFaceIDEnabled {
                authenticateWithBiometrics()
            } else {
                showMainApp()
            }
        } else {
            showLogin()
        }
    }

    private func showLogin() {
        let loginViewModel = dependencies.makeLoginViewModel()
        loginViewModel.delegate = self

        let loginViewController = LoginViewController(loginViewModel: loginViewModel)
        navigationController.pushViewController(loginViewController, animated: false)
    }

    private func showMainApp() {
        let tabBarCoordinator = dependencies
            .makeTabBarCoordinator(navigationController: navigationController)
        self.tabBarCoordinator = tabBarCoordinator
        tabBarCoordinator.start()
    }

    private func showFakeWebLogin() {
        let url = URL(string: "https://ibb.co/KcFN223Q")!
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        navigationController.present(safariVC, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
            safariVC.dismiss(animated: true) {
                self?.showMainApp()
            }
        }
    }

    private func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Выполните вход с помощью Face ID"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authError in
                DispatchQueue.main.async {
                    if success {
                        self?.showMainApp()
                    } else {
                        self?.showLogin()
                    }
                }
            }
        } else {
            showLogin()
        }
    }
}

extension MainCoordinator: LoginViewModelDelegate {
    func didLogin() {
        showFakeWebLogin()
    }
}

extension MainCoordinator: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        showMainApp()
    }
}
