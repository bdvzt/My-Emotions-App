//
//  JournalUITests.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 04.03.2025.
//

import XCTest

private extension JournalUITests {
    enum MockData {
        static let mockMoods: [String] = [
            "выгорание",
            "спокойствие",
            "продуктивность",
            "беспокойство"
        ]
    }
}

final class JournalUITests: BasePage {
    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        app.activate()
    }

    // MARK: - Tests

    func testSuccessJournalScreen() {
        let journalPage = JournalPage()
        journalPage.assertJournalScreenIsOpened()
        journalPage.assertMoodCardsExist()
        MockData.mockMoods.forEach { moodText in
            journalPage.assertMoodCardExists(moodText: moodText)
        }
    }

    func testEmptyStateJournalScreen() {
        let journalPage = JournalPage()
        journalPage.assertJournalScreenIsOpened()
        let emptyLabel = journalPage.app.staticTexts["emptyStateLabel"]
        XCTAssertTrue(emptyLabel.exists, "Должен быть лейбл пустого состояния")
    }

    func testErrorStateJournalScreen() {
        let journalPage = JournalPage()
        journalPage.assertJournalScreenIsOpened()
        let errorLabel = journalPage.app.staticTexts["errorLabel"]
        XCTAssertTrue(errorLabel.waitForExistence(timeout: 5), "❌ Должен отображаться лейбл ошибки")
        let moodCardScrollView = journalPage.app.scrollViews["moodCardScrollView"]
        XCTAssertFalse(moodCardScrollView.exists, "❌ Карточки настроения не должны отображаться при ошибке")
        let emptyStateLabel = journalPage.app.staticTexts["emptyStateLabel"]
        XCTAssertFalse(emptyStateLabel.exists, "❌ Лейбл пустого состояния не должен отображаться при ошибке")
    }
}
