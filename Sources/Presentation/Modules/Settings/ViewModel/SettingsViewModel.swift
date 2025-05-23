//
//  SettingsViewModel.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 13.05.2025.
//

import Combine
import UIKit
import AVFoundation
import LocalAuthentication

protocol SettingsViewModelDelegate: AnyObject {
    func didRequestLogout()
    func presentCameraPicker()
    func presentPhotoPicker()
    func presentCameraAccessAlert()
    func updateFaceIDSwitch(to isOn: Bool)
    func showFaceIDError(message: String)
}

final class SettingsViewModel {

    // MARK: - Properties
    weak var delegate: SettingsViewModelDelegate?
    private var repository: SettingsRepository

    // MARK: - Published
    @Published var reminderTimes: [String]
    @Published var isRemindersEnabled: Bool
    @Published var isFaceIDEnabled: Bool

    // MARK: - Init
    init(delegate: SettingsViewModelDelegate? = nil, repository: SettingsRepository) {
        self.delegate = delegate
        self.repository = repository

        self.reminderTimes = repository.reminderTimes
        self.isRemindersEnabled = repository.isRemindersEnabled
        self.isFaceIDEnabled = repository.isFaceIDEnabled
    }

    // MARK: - User information
    var firstName: String { repository.firstName }
    var lastName: String { repository.lastName }
    var avatar: UIImage { repository.avatar }

    // MARK: - Actions
    func addReminderTime(_ time: String) {
        repository.addReminderTime(time)
        reminderTimes = repository.reminderTimes
    }

    func deleteReminderTime(_ time: String) {
        repository.deleteReminderTime(time)
        reminderTimes = repository.reminderTimes
    }

    func setFaceIDEnabled(_ isOn: Bool) {
        repository.isFaceIDEnabled = isOn
        isFaceIDEnabled = isOn
    }

    func setRemindersEnabled(_ isOn: Bool) {
        repository.isRemindersEnabled = isOn
        isRemindersEnabled = isOn
    }

    func logoutTapped() {
        delegate?.didRequestLogout()
    }

    func updateAvatar(_ image: UIImage) {
        repository.saveAvatar(image)
    }

    func didTapCameraOption() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)

        switch status {
        case .authorized:
            delegate?.presentCameraPicker()

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    granted ? self?.delegate?.presentCameraPicker() : self?.delegate?.presentCameraAccessAlert()
                }
            }

        case .denied, .restricted:
            delegate?.presentCameraAccessAlert()

        default: break
        }
    }

    func didTapGalleryOption() {
        delegate?.presentPhotoPicker()
    }
}

extension SettingsViewModel {
    func toggleFaceID(to isOn: Bool) {
        if isOn {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Для включения Face ID") { [weak self] success, authError in
                    DispatchQueue.main.async {
                        if success {
                            self?.setFaceIDEnabled(true)
                            self?.delegate?.updateFaceIDSwitch(to: true)
                        } else {
                            self?.setFaceIDEnabled(false)
                            self?.delegate?.updateFaceIDSwitch(to: false)
                            self?.delegate?.showFaceIDError(message: authError?.localizedDescription ?? "Ошибка аутентификации")
                        }
                    }
                }
            } else {
                setFaceIDEnabled(false)
                delegate?.updateFaceIDSwitch(to: false)
                delegate?.showFaceIDError(message: error?.localizedDescription ?? "Face ID недоступен на устройстве")
            }
        } else {
            setFaceIDEnabled(false)
            delegate?.updateFaceIDSwitch(to: false)
        }
    }
}
