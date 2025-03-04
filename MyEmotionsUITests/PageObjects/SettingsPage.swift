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
        static let settingsLabel = "settingsLabel"
        static let avatarView = "avatarView"
        static let touchIdSwitchBar = "touchIdSwitchBar"
        static let sendAlert = "sendAlert"
        static let timePicker = "timePicker"
        static let saveButton = "saveButton"
    }
}

final class SettingsPage: BasePage {
    private lazy var settingsScreenTitle = app.otherElements[.Identifier.settingsScreen]
    private lazy var settingsLabel = app.staticTexts[.Identifier.settingsLabel]
    private lazy var avatarView = app.otherElements[.Identifier.avatarView]
    private lazy var addReminderButton = app.buttons[.Identifier.addReminderButton]
    private lazy var timeScrollView = app.scrollViews[.Identifier.timeScrollView]
    private lazy var emptyStateLabel = app.staticTexts[.Identifier.emptyStateLabel]
    private lazy var errorLabel = app.staticTexts[.Identifier.errorLabel]
    private lazy var touchIdSwitchBar = app.otherElements[.Identifier.touchIdSwitchBar]
    private lazy var sendAlert = app.otherElements[.Identifier.sendAlert]
    private lazy var timePicker = app.datePickers[.Identifier.timePicker]
    private lazy var saveButton = app.buttons[.Identifier.saveButton]

    @discardableResult
    func assertSettingsScreenIsOpened() -> SettingsPage {
        XCTAssertTrue(settingsScreenTitle.waitForExistence(timeout: 5), "Экран настроек не открылся")
        return self
    }

    @discardableResult
    func assertSettingsTitleExists() -> SettingsPage {
        XCTAssertTrue(settingsLabel.exists, "Нет заголовка 'Настройки'")
        return self
    }

    @discardableResult
    func assertAvatarExists() -> SettingsPage {
        XCTAssertTrue(avatarView.exists, "Нет аватара пользователя")
        return self
    }

    @discardableResult
    func assertAddReminderButtonExists() -> SettingsPage {
        XCTAssertTrue(addReminderButton.exists, "Нет кнопки 'Добавить напоминание'")
        return self
    }

    @discardableResult
    func assertRemindersExist() -> SettingsPage {
        let reminderCount = timeScrollView.children(matching: .other).count
        XCTAssertGreaterThan(reminderCount, 0, "Нет напоминаний")
        return self
    }

    @discardableResult
    func assertEmptyStateExists() -> SettingsPage {
        XCTAssertTrue(emptyStateLabel.exists, "Нет лейбла пустого состояния")
        return self
    }

    @discardableResult
    func assertErrorStateExists() -> SettingsPage {
        XCTAssertTrue(errorLabel.exists, "Нет лейбла ошибки")
        return self
    }

    @discardableResult
    func assertTouchIdSwitchExists() -> SettingsPage {
        XCTAssertTrue(touchIdSwitchBar.exists, "Нет переключателя Touch ID")
        return self
    }

    @discardableResult
    func assertSendAlertExists() -> SettingsPage {
        XCTAssertTrue(sendAlert.exists, "Нет переключателя отправки уведомлений")
        return self
    }

    @discardableResult
    func assertTimePickerExists() -> SettingsPage {
        XCTAssertTrue(timePicker.exists, "Нет таймпикера")
        return self
    }

    @discardableResult
    func assertSaveButtonExists() -> SettingsPage {
        XCTAssertTrue(saveButton.exists, "Нет кнопки 'Сохранить'")
        return self
    }

    func tapAddReminderButton() {
        XCTAssertTrue(addReminderButton.exists, "Нет кнопки 'Добавить напоминание'")
        addReminderButton.tap()
    }

    func tapSaveButton() {
        XCTAssertTrue(saveButton.exists, "Нет кнопки 'Сохранить'")
        saveButton.tap()
    }
}
