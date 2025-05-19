//
//  LoginViewModel.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 30.04.2025.
//

import AuthenticationServices

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

    func handleWithAppleId() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    private func saveUserNameIfNeeded(givenName: String, familyName: String) {
        let hasSavedName = UserDefaults.standard.bool(forKey: "hasSavedUserName")
        guard hasSavedName == false else { return }

        UserDefaults.standard.set(givenName, forKey: "user_given_name")
        UserDefaults.standard.set(familyName, forKey: "user_family_name")
        UserDefaults.standard.set(true, forKey: "hasSavedUserName")
    }
}

extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredentials = authorization.credential as? ASAuthorizationAppleIDCredential {
            let fullName = appleIDCredentials.fullName
            let givenName = fullName?.givenName ?? ""
            let familyName = fullName?.familyName ?? ""

            saveUserNameIfNeeded(givenName: givenName, familyName: familyName)
            delegate?.didLogin()
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        print("apple id error: \(error.localizedDescription)")
    }
}

extension LoginViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.windows.first { $0.isKeyWindow } ?? UIWindow()
    }
}
