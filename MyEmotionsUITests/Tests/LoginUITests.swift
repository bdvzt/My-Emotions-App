//
//  LoginUITests.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 04.03.2025.
//

import XCTest

final class LoginUITests: BasePage {

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        app.activate()
    }

    func testSuccessLoginScreen() {
        let loginPage = LoginPage()

        loginPage.assertLoginScreenIsOpened()
        loginPage.assertWelcomeLabelExists()
        loginPage.assertLoginButtonExists()
    }

    func testLoginButtonTapNavigatesToTabBar() {
        let loginPage = LoginPage()

        loginPage.assertLoginScreenIsOpened()
        loginPage.tapLoginButton()

        let tabBar = XCUIApplication().tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5), "TabBarController не открылся плаки плаки")
    }
}
