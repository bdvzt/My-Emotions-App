//
//  SettingsPage.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 04.03.2025.
//

import XCTest

private extension String {
    enum Identifier {
        static let settingsScreen = "settingsScreen"
        static let addReminderButton = "addReminderButton"
        static let timeScrollView = "timeScrollView"
        static let emptyStateLabel = "emptyStateLabel"
        static let errorLabel = "errorLabel"
    }
}

final class SettingsPage: BasePage {

    // MARK: - Elements

    private lazy var settingsScreenTitle = app.otherElements[.Identifier.settingsScreen]
    private lazy var addReminderButton = app.buttons[.Identifier.addReminderButton]
    private lazy var timeScrollView = app.scrollViews[.Identifier.timeScrollView]
    private lazy var emptyStateLabel = app.staticTexts[.Identifier.emptyStateLabel]
    private lazy var errorLabel = app.staticTexts[.Identifier.errorLabel]

    // MARK: - Actions

    @discardableResult
    func assertSettingsScreenIsOpened() -> SettingsPage {
        XCTAssertTrue(settingsScreenTitle.waitForExistence(timeout: 5), "❌ Экран настроек не открылся")
        return self
    }

    @discardableResult
    func assertRemindersExist() -> SettingsPage {
        let reminderCount = timeScrollView.children(matching: .other).count
        XCTAssertGreaterThan(reminderCount, 0, "❌ Ожидалось, что есть хотя бы одно напоминание, но их нет.")
        return self
    }

    @discardableResult
    func assertEmptyStateExists() -> SettingsPage {
        XCTAssertTrue(emptyStateLabel.waitForExistence(timeout: 5), "❌ Должен отображаться лейбл пустого состояния")
        return self
    }

    @discardableResult
    func assertErrorStateExists() -> SettingsPage {
        XCTAssertTrue(errorLabel.waitForExistence(timeout: 5), "❌ Должен отображаться лейбл ошибки")
        return self
    }
}
