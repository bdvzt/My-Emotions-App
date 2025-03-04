//
//  LoginPage.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 04.03.2025.
//

import XCTest

private extension String {
    enum Identifier {
        static let loginScreen = "loginScreen"
        static let welcomeLabel = "welcomeLabel"
        static let loginButton = "loginButton"
    }
}

final class LoginPage: BasePage {

    private lazy var welcomeLabel = app.staticTexts["welcomeLabel"]
    private lazy var loginButton = app.otherElements[.Identifier.loginButton]

    @discardableResult
    func assertLoginScreenIsOpened() -> LoginPage {
        XCTAssertTrue(welcomeLabel.waitForExistence(timeout: 5), "Экран логина не открылся или нет лейбла")
        return self
    }

    @discardableResult
    func assertWelcomeLabelExists() -> LoginPage {
        XCTAssertTrue(welcomeLabel.exists, "Нет лейбла 'Добро пожаловать'")
        return self
    }

    @discardableResult
    func assertLoginButtonExists() -> LoginPage {
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5), "Нет кнопки входа")
        return self
    }

    @discardableResult
    func tapLoginButton() -> LoginPage {
        XCTAssertTrue(loginButton.exists, "Нет кнопки входа")
        loginButton.tap()
        return self
    }
}
