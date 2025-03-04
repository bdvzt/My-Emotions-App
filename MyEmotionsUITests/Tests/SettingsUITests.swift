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
        app.launch()
        app.activate()
        navigateToSettingsScreen()
    }

    func testSuccessSettingsScreen() {
        let settingsPage = SettingsPage()
        settingsPage.assertSettingsScreenIsOpened()
        settingsPage.assertSettingsTitleExists()
        settingsPage.assertAvatarExists()
        settingsPage.assertSendAlertExists()
        settingsPage.assertAddReminderButtonExists()
        settingsPage.assertTouchIdSwitchExists()
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

    func testAddReminderButton() {
        let settingsPage = SettingsPage()
        settingsPage.assertSettingsScreenIsOpened()
        settingsPage.assertAddReminderButtonExists()

        settingsPage.tapAddReminderButton()
        settingsPage.assertTimePickerExists()
    }

    func testAddReminder() {
        let settingsPage = SettingsPage()
        settingsPage.assertSettingsScreenIsOpened()
        settingsPage.assertAddReminderButtonExists()

        settingsPage.tapAddReminderButton()
        settingsPage.assertTimePickerExists()

        settingsPage.tapSaveButton()
        settingsPage.assertRemindersExist()
    }

    private func navigateToSettingsScreen() {
        let loginButton = app.otherElements["loginButton"]

        XCTAssertTrue(loginButton.waitForExistence(timeout: 5), "Нет кнопки входа")
        loginButton.tap()

        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5), "TabBarController не открылся")

        let settingsTab = tabBar.buttons["Настройка"]
        XCTAssertTrue(settingsTab.waitForExistence(timeout: 5), "В таббаре 'Настройки' не появились")

        if !settingsTab.isSelected {
            settingsTab.tap()
        }

        let settingsScreen = app.otherElements["settingsScreen"]
        XCTAssertTrue(settingsScreen.waitForExistence(timeout: 5), "Экран настроек не открылся")
    }
}
