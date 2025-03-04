//
//  JournalPage.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 04.03.2025.
//

import XCTest

private extension String {
    enum Identifier {
        static let journalScreen = "journalScreen"
        static let addMoodButton = "addMoodButton"
        static let moodCardScrollView = "moodCardScrollView"
        static let cardsContainerView = "cardsContainerView"
        static let emptyStateLabel = "emptyStateLabel"
        static let errorLabel = "errorLabel"
    }
}

final class JournalPage: BasePage {

    // MARK: - Elements

    private lazy var journalScreenTitle = app.otherElements[.Identifier.journalScreen]
    private lazy var addMoodButton = app.buttons[.Identifier.addMoodButton]
    private lazy var moodCards = app.scrollViews[.Identifier.cardsContainerView].otherElements
    private lazy var emptyStateLabel = app.otherElements[.Identifier.emptyStateLabel]
    private lazy var errorLabel = app.otherElements[.Identifier.errorLabel]

    // MARK: - Actions

    @discardableResult
    func assertJournalScreenIsOpened() -> JournalPage {
        XCTAssertTrue(journalScreenTitle.waitForExistence(timeout: 5), "Журнал не открылся")
        return self
    }

    @discardableResult
    func assertMoodCardsExist() -> JournalPage {
        let cardCount = app.otherElements.matching(NSPredicate(format: "identifier BEGINSWITH 'moodCard_'")).count
        XCTAssertGreaterThan(cardCount, 0, "❌ Ожидалось, что есть хотя бы одна карточка настроения, но их нет.")
        return self
    }

    @discardableResult
    func assertMoodCardExists(moodText: String) -> JournalPage {
        let moodCard = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", moodText)).element
        XCTAssertTrue(moodCard.waitForExistence(timeout: 5), "❌ Карточка с настроением '\(moodText)' не найдена.")
        return self
    }

    @discardableResult
    func assertErrorLabelExists() -> JournalPage {
        XCTAssertTrue(errorLabel.waitForExistence(timeout: 5), "❌ Лейбл ошибки не найден.")
        return self
    }
}
