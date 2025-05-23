//
//  SettingsCoordinator.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 13.05.2025.
//

import UIKit
import PhotosUI

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
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive) { [weak self] _ in
            self?.logout()
        })
        navigationController.present(alert, animated: true)
    }

    func presentCameraPicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }

        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = navigationController.topViewController as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        navigationController.present(picker, animated: true)
    }

    func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)

        if let topVC = navigationController.topViewController as? PHPickerViewControllerDelegate & UIViewController {
            picker.delegate = topVC
            topVC.present(picker, animated: true)
        } else {
            print("ыааааа")
        }
    }

    func presentCameraAccessAlert() {
        let alert = UIAlertController(
            title: "Нет доступа к камере",
            message: "Разрешите доступ в настройках, чтобы использовать камеру.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Открыть настройки", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })

        navigationController.present(alert, animated: true)
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

    func updateFaceIDSwitch(to isOn: Bool) {
        guard let vc = navigationController.topViewController as? SettingsViewController else { return }
        vc.setFaceIDSwitchState(isOn)
    }

    func showFaceIDError(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Face ID недоступен",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Открыть настройки", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))

        navigationController.present(alert, animated: true)
    }
}

