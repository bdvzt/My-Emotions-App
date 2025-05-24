//
//  MockSettingsDelegate.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 24.05.2025.
//

import Foundation
@testable import MyEmotions

final class MockSettingsDelegate: SettingsViewModelDelegate {
    var didRequestLogoutCalled = false
    var presentCameraPickerCalled = false
    var presentPhotoPickerCalled = false
    var presentCameraAccessAlertCalled = false
    var updateFaceIDSwitchCalledWith: Bool?
    var showFaceIDErrorCalledWith: String?

    func didRequestLogout() { didRequestLogoutCalled = true }
    func presentCameraPicker() { presentCameraPickerCalled = true }
    func presentPhotoPicker() { presentPhotoPickerCalled = true }
    func presentCameraAccessAlert() { presentCameraAccessAlertCalled = true }
    func updateFaceIDSwitch(to isOn: Bool) { updateFaceIDSwitchCalledWith = isOn }
    func showFaceIDError(message: String) { showFaceIDErrorCalledWith = message }
}
