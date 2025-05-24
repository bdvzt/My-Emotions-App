//
//  AddNoteViewModelTests.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 24.05.2025.
//

import XCTest
@testable import MyEmotions

final class AddNoteViewModelTests: XCTestCase {

    private var repository: MockJournalListRepository!
    private var answerRepository: MockNoteAnswersRepository!
    private var mood: Mood!
    private var viewModel: AddNoteViewModel!

    override func setUp() {
        super.setUp()
        repository = MockJournalListRepository()
        answerRepository = MockNoteAnswersRepository()
        mood = Mood(id: UUID(), title: "Test", icon: "icon", moodInfo: "info", colorType: .green)
        viewModel = AddNoteViewModel(
            selectedMood: mood,
            repository: repository,
            noteAnswersRepository: answerRepository
        )
    }

    override func tearDown() {
        repository = nil
        answerRepository = nil
        mood = nil
        viewModel = nil
        super.tearDown()
    }

    /// проверка, что карточка сохраняется в репозиторий с корректными тегами
    func testSaveNote_shouldStoreCorrectCardInRepository() async {
        viewModel.activitiesViewModel.setSelectedAnswers(["Тренировка"])
        viewModel.peopleViewModel.setSelectedAnswers(["Один"])
        viewModel.placesViewModel.setSelectedAnswers(["Дом"])

        await viewModel.saveNote()

        guard let saved = repository.savedCards.last else {
            XCTFail("Card was not saved")
            return
        }

        XCTAssertEqual(saved.mood.id, mood.id)
        XCTAssertEqual(saved.activities, ["Тренировка"])
        XCTAssertEqual(saved.people, ["Один"])
        XCTAssertEqual(saved.places, ["Дом"])
    }

    /// проверка, что выбранные пользователем теги сохраняются во viewModel
    func testSetSelectedAnswers_shouldRetainUserSelection() {
        viewModel.activitiesViewModel.setSelectedAnswers(["Отдых"])
        viewModel.peopleViewModel.setSelectedAnswers(["Друзья"])
        viewModel.placesViewModel.setSelectedAnswers(["Работа"])

        XCTAssertEqual(viewModel.activitiesViewModel.selectedAnswers, ["Отдых"])
        XCTAssertEqual(viewModel.peopleViewModel.selectedAnswers, ["Друзья"])
        XCTAssertEqual(viewModel.placesViewModel.selectedAnswers, ["Работа"])
    }

    /// проверка, что создаётся новая карточка при отсутствии existingCard
    func testSaveNote_shouldCreateNewCardIfNoExisting() async {
        await viewModel.saveNote()

        XCTAssertEqual(repository.savedCards.count, 1)
        XCTAssertNotNil(repository.savedCards.first?.id)
    }

    /// проверка, что при переданном existingCard сохраняется тот же id
    func testSaveNote_shouldUpdateExistingCard() async {
        let cardId = UUID()
        let existingCard = MoodCard(id: cardId, date: Date(), mood: mood, activities: [], people: [], places: [])

        viewModel = AddNoteViewModel(
            selectedMood: mood,
            repository: repository,
            noteAnswersRepository: answerRepository,
            existingCard: existingCard
        )

        await viewModel.saveNote()

        XCTAssertEqual(repository.savedCards.first?.id, cardId)
    }

    /// проверка вызова делегата при сохранении
    func testSaveNote_shouldCallDelegateOnSave() async {
        final class MockDelegate: AddNoteViewModelDelegate {
            var didCall = false
            func didSaveNote() { didCall = true }
        }

        let mockDelegate = MockDelegate()
        viewModel.delegate = mockDelegate

        await viewModel.saveNote()

        XCTAssertTrue(mockDelegate.didCall)
    }
}
