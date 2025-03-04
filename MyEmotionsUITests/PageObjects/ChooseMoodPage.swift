//
//  ChooseMoodPage.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 04.03.2025.
//

import XCTest

private extension String {
    enum Identifier {
        static let chooseMoodScreen = "chooseMoodScreen"
        static let backArrow = "backArrow"
        static let moodGrid = "moodGrid"
        static let moodCardContainer = "moodCardContainer"
        static let addNoteButton = "addNoteButton"
    }
}

final class ChooseMoodPage: BasePage {

    // MARK: - Elements

    private lazy var chooseMoodScreenTitle = app.otherElements[.Identifier.chooseMoodScreen]
    private lazy var backArrowButton = app.buttons[.Identifier.backArrow]
    private lazy var moodGrid = app.scrollViews[.Identifier.moodGrid]
    private lazy var moodCardContainer = app.otherElements[.Identifier.moodCardContainer]
    private lazy var moodCards = moodCardContainer.otherElements
    private lazy var addNoteButton = app.buttons[.Identifier.addNoteButton]

    // MARK: - Actions

    /// Проверяет, что экран выбора настроения открыт
    @discardableResult
    func assertChooseMoodScreenIsOpened() -> ChooseMoodPage {
        XCTAssertTrue(chooseMoodScreenTitle.waitForExistence(timeout: 5), "Экран выбора настроения не открылся")
        return self
    }

    /// Проверяет, что сетка настроений загружена
    @discardableResult
    func assertMoodGridExists() -> ChooseMoodPage {
        XCTAssertTrue(moodGrid.waitForExistence(timeout: 5), "Сетка настроений не загружена")
        return self
    }

    /// Выбирает настроение по его названию
    @discardableResult
    func selectMood(mood: String) -> ChooseMoodPage {
        let moodButton = app.staticTexts[mood]
        XCTAssertTrue(moodButton.waitForExistence(timeout: 5), "Настроение \(mood) не найдено")
        moodButton.tap()
        return self
    }

    /// Проверяет, что карточка настроения была выбрана
    @discardableResult
    func assertMoodCardExists() -> ChooseMoodPage {
        XCTAssertGreaterThan(moodCards.count, 0, "Ожидалась хотя бы одна карточка настроения")
        return self
    }

    /// Нажимает на кнопку "Добавить заметку"
    @discardableResult
    func tapAddNoteButton() -> AddNotePage {
        addNoteButton.tap()
        return AddNotePage()
    }

    /// Нажимает на кнопку "Назад"
    @discardableResult
    func tapBackArrow() -> JournalPage {
        backArrowButton.tap()
        return JournalPage()
    }
}
