//
//  AddNotePage.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 04.03.2025.
//

import XCTest

private extension String {
    enum Identifier {
        static let addNoteScreen = "addNoteScreen"
        static let backArrow = "backArrow"
        static let moodCard = "moodCard"
        static let saveButton = "saveButton"
    }
}

final class AddNotePage: BasePage {

    // MARK: - Elements

    private lazy var addNoteScreenTitle = app.otherElements[.Identifier.addNoteScreen]
    private lazy var backArrowButton = app.buttons[.Identifier.backArrow]
    private lazy var moodCard = app.otherElements[.Identifier.moodCard]
    private lazy var whatQuestionView = app.staticTexts["Чем вы занимались?"]
    private lazy var withWhomQuestionView = app.staticTexts["С кем вы были?"]
    private lazy var whereQuestionView = app.staticTexts["Где вы были?"]
    private lazy var saveButton = app.buttons[.Identifier.saveButton]

    // MARK: - Actions

    @discardableResult
    func assertAddNoteScreenIsOpened() -> AddNotePage {
        XCTAssertTrue(addNoteScreenTitle.waitForExistence(timeout: 5), "Экран добавления заметки не открылся")
        return self
    }

    @discardableResult
    func assertMoodCardExists() -> AddNotePage {
        XCTAssertTrue(moodCard.waitForExistence(timeout: 5), "Карточка настроения не отображается")
        return self
    }

    @discardableResult
    func assertQuestionsExist() -> AddNotePage {
        XCTAssertTrue(whatQuestionView.waitForExistence(timeout: 5), "Вопрос 'Чем вы занимались?' не найден")
        XCTAssertTrue(withWhomQuestionView.waitForExistence(timeout: 5), "Вопрос 'С кем вы были?' не найден")
        XCTAssertTrue(whereQuestionView.waitForExistence(timeout: 5), "Вопрос 'Где вы были?' не найден")
        return self
    }

    @discardableResult
    func selectAnswer(answer: String) -> AddNotePage {
        let answerButton = app.staticTexts[answer]
        XCTAssertTrue(answerButton.waitForExistence(timeout: 5), "Ответ \(answer) не найден")
        answerButton.tap()
        return self
    }

    @discardableResult
    func tapSaveButton() -> JournalPage {
        saveButton.tap()
        return JournalPage()
    }

    @discardableResult
    func tapBackArrow() -> ChooseMoodPage {
        backArrowButton.tap()
        return ChooseMoodPage()
    }
}
