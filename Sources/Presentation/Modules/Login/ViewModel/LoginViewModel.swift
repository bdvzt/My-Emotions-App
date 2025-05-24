//
//  LoginViewModel.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 30.04.2025.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func didLogin()
}

final class LoginViewModel: NSObject {

    // MARK: - Delegate
    weak var delegate: LoginViewModelDelegate?
    private var repository: SettingsRepository

    init(repository: SettingsRepository) {
        self.repository = repository
    }

    // MARK: - Actions
    func didTapLoginButton() {
        repository.saveUserNameIfNeeded(givenName: "Степан", familyName: "Потапов")
        delegate?.didLogin()
    }

    private func saveUserNameIfNeeded(givenName: String, familyName: String) {
        let hasSavedName = UserDefaults.standard.bool(forKey: "hasSavedUserName")
        guard hasSavedName == false else { return }

        UserDefaults.standard.set(givenName, forKey: "user_given_name")
        UserDefaults.standard.set(familyName, forKey: "user_family_name")
        UserDefaults.standard.set(true, forKey: "hasSavedUserName")
    }
}
