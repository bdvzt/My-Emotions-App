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
    private lazy var journalScreenTitle = app.otherElements[.Identifier.journalScreen]
    private lazy var addMoodButton = app.otherElements[.Identifier.addMoodButton]
    private lazy var moodCards = app.scrollViews[.Identifier.cardsContainerView].otherElements
    private lazy var emptyStateLabel = app.staticTexts[.Identifier.emptyStateLabel]
    private lazy var errorLabel = app.staticTexts[.Identifier.errorLabel]
    private lazy var progressCircle = app.otherElements["circleProgressBar"]
    private lazy var scrollView = app.scrollViews[.Identifier.moodCardScrollView]

    @discardableResult
    func assertJournalScreenIsOpened() -> JournalPage {
        XCTAssertTrue(journalScreenTitle.waitForExistence(timeout: 5), "Экран журнала не открылся")
        return self
    }

    @discardableResult
    func assertTitleExists() -> JournalPage {
        XCTAssertTrue(journalScreenTitle.exists, "Нет заголовка")
        return self
    }

    @discardableResult
    func assertProgressCircleExists() -> JournalPage {
        XCTAssertTrue(progressCircle.exists, "Нет прогресс-бара")
        return self
    }

    @discardableResult
    func assertMoodCardsExist() -> JournalPage {
        let cardCount = app.otherElements.matching(NSPredicate(format: "identifier BEGINSWITH 'moodCard_'")).count
        XCTAssertGreaterThan(cardCount, 0, "Нет карточек настроения")
        return self
    }

    @discardableResult
    func assertMoodCardExists(moodText: String) -> JournalPage {
        let moodCard = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", moodText)).element
        XCTAssertTrue(moodCard.waitForExistence(timeout: 5), "Нет карточки с настроением '\(moodText)'")
        return self
    }

    @discardableResult
    func assertAddMoodButtonExists() -> JournalPage {
        XCTAssertTrue(addMoodButton.exists, "Нет кнопки 'Добавить запись'")
        return self
    }

    @discardableResult
    func assertEmptyStateLabelExists() -> JournalPage {
        XCTAssertTrue(emptyStateLabel.exists, "Нет лейбла пустого состояния")
        return self
    }

    @discardableResult
    func assertEmptyStateLabelNotExists() -> JournalPage {
        XCTAssertFalse(emptyStateLabel.exists, "Лейбл пустого состояния не должен отображаться")
        return self
    }

    @discardableResult
    func assertErrorLabelExists() -> JournalPage {
        XCTAssertTrue(errorLabel.exists, "Нет лейбла ошибки")
        return self
    }

    @discardableResult
    func assertScrollViewNotExists() -> JournalPage {
        XCTAssertFalse(scrollView.exists, "Скролл с карточками не должен отображаться")
        return self
    }
}
