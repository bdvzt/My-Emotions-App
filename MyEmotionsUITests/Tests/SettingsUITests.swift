//
//  SettingsUITests.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 04.03.2025.
//

import XCTest

final class SettingsUITests: BasePage {
    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        app.activate()
    }

    // MARK: - Tests

    func testSuccessSettingsScreen() {
        let settingsPage = SettingsPage()
        settingsPage.assertSettingsScreenIsOpened()
        settingsPage.assertRemindersExist()
    }

    func testEmptyStateSettingsScreen() {
        let settingsPage = SettingsPage()
        settingsPage.assertSettingsScreenIsOpened()
        settingsPage.assertEmptyStateExists()
    }

    func testErrorStateSettingsScreen() {
        let settingsPage = SettingsPage()
        settingsPage.assertSettingsScreenIsOpened()
        settingsPage.assertErrorStateExists()
    }
}
