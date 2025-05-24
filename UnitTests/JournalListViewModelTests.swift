//
//  JournalListViewModelTests.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 24.05.2025.
//

import XCTest
@testable import MyEmotions

final class JournalListViewModelTests: XCTestCase {

    private var mockRepository: MockJournalListRepository!
    private var mockStatRepository: MockNoteStatRepository!
    private var viewModel: JournalListViewModel!

    override func setUp() {
        super.setUp()
        mockRepository = MockJournalListRepository()
        mockStatRepository = MockNoteStatRepository()
        viewModel = JournalListViewModel(repository: mockRepository, statRepository: mockStatRepository)
    }

    override func tearDown() {
        mockRepository = nil
        mockStatRepository = nil
        viewModel = nil
        super.tearDown()
    }

    /// проверяет, что fetchMoodCards обновляет список карточек и view model карточек
    func testFetchMoodCards_shouldUpdateCardsAndMoodCards() async {
        let mood = MockMoods.moods.first!
        let card = MoodCard(id: UUID(), date: Date(), mood: mood, activities: [], people: [], places: [])
        mockRepository.cards = [card]

        await viewModel.fetchMoodCards()

        XCTAssertEqual(viewModel.cards.count, 1)
        XCTAssertEqual(viewModel.moodCards.count, 1)
        XCTAssertEqual(viewModel.cards.first?.id, card.id)
    }

    /// проверяет, что deleteCard удаляет карточку из репозитория и вызывает обновление данных
    func testDeleteCard_shouldRemoveCardFromRepositoryAndFetchAgain() async {
        let card = MoodCard(id: UUID(), date: Date(), mood: MockMoods.moods[1], activities: [], people: [], places: [])
        mockRepository.cards = [card]

        await viewModel.deleteCard(with: card.id)

        XCTAssertTrue(mockRepository.deletedCardIDs.contains(card.id))
        XCTAssertEqual(viewModel.cards.count, 0)
    }

    /// проверяет, что updateDailyGoal вызывает соответствующую функцию в репозитории
    func testUpdateDailyGoal_shouldCallRepositoryUpdate() {
        viewModel.updateDailyGoal(5)

        XCTAssertEqual(mockStatRepository.updatedGoal, 5)
    }

    /// проверяет, что getNoteStatistics возвращает заранее заданные значения
    @MainActor
    func testGetNoteStatistics_shouldReturnMockedStats() {
        let stats = viewModel.getNoteStatistics()

        XCTAssertEqual(stats.totalCount, 10)
        XCTAssertEqual(stats.dailyGoal, 3)
        XCTAssertEqual(stats.streak, 2)
    }

    /// проверяет, что didTapCard не вызывает ошибки, если id не найден
    func testDidTapCard_shouldNotCrashIfCardNotFound() {
        let unknownID = UUID()
        viewModel.didTapCard(with: unknownID)

        // ничего не происходит — тест проходит, если нет сбоев
        XCTAssertTrue(true)
    }

    /// проверяет, что saveMoodCard сохраняет новую карточку в репозитории
    func testSaveMoodCard_shouldAppendCardToRepository() async throws {
        let newCard = MoodCard(id: UUID(), date: Date(), mood: MockMoods.moods[2], activities: ["test"], people: [], places: [])
        try await mockRepository.saveMoodCard(card: newCard)

        XCTAssertEqual(mockRepository.cards.count, 1)
        XCTAssertEqual(mockRepository.savedCards.first?.id, newCard.id)
    }
}
