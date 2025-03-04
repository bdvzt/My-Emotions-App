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
        app.launch()
        app.activate()
        navigateToJournalScreen()
    }

    func testSuccessJournalScreen() {
        let journalPage = JournalPage()

        journalPage.assertJournalScreenIsOpened()
        journalPage.assertTitleExists()
        journalPage.assertProgressCircleExists()
        journalPage.assertMoodCardsExist()
        journalPage.assertAddMoodButtonExists()

        MockData.mockMoods.forEach { moodText in
            journalPage.assertMoodCardExists(moodText: moodText)
        }
    }

    func testEmptyStateJournalScreen() {
        let journalPage = JournalPage()

        journalPage.assertJournalScreenIsOpened()
        journalPage.assertEmptyStateLabelExists()
        journalPage.assertAddMoodButtonExists()
    }

    func testErrorStateJournalScreen() {
        let journalPage = JournalPage()

        journalPage.assertJournalScreenIsOpened()
        journalPage.assertErrorLabelExists()
        journalPage.assertScrollViewNotExists()
        journalPage.assertEmptyStateLabelNotExists()
    }

    private func navigateToJournalScreen() {
        let loginButton = app.otherElements["loginButton"]

        XCTAssertTrue(loginButton.waitForExistence(timeout: 5), "Нет кнопки входа")
        loginButton.tap()

        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5), "TabBarController не открылся")

        let journalTab = tabBar.buttons["Журнал"]
        XCTAssertTrue(journalTab.waitForExistence(timeout: 5), "Журнал не появился")

        if !journalTab.isSelected {
            journalTab.tap()
        }

        let journalScreen = app.otherElements["journalScreen"]
        XCTAssertTrue(journalScreen.waitForExistence(timeout: 5), "Экран журнала не открылся")
    }
}
