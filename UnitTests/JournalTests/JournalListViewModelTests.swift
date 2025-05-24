//
//  JournalListViewModelTests.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 24.05.2025.
//

import XCTest
@testable import MyEmotions

final class JournalListViewModelTests: XCTestCase {

    private var viewModel: JournalListViewModel!
    private var repository: MockJournalListRepository!
    private var statRepository: MockNoteStatRepository!

    override func setUp() {
        super.setUp()
        repository = MockJournalListRepository()
        statRepository = MockNoteStatRepository()
        viewModel = JournalListViewModel(repository: repository, statRepository: statRepository)
    }

    private func makeMoodCard(date: Date, moodColor: MoodColorType) -> MoodCard {
        let mood = Mood(
            id: UUID(),
            title: "Test Mood",
            icon: "icon",
            moodInfo: "info",
            colorType: moodColor
        )
        return MoodCard(
            id: UUID(),
            date: date,
            mood: mood,
            activities: [],
            people: [],
            places: []
        )
    }

    /// карточки сортируются по дате убыванию
    func testFetchMoodCards_shouldReturnCardsSortedByDateDescending() async {
        let calendar = Calendar.current
        let today = Date().startOfDay
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!

        let card1 = makeMoodCard(date: yesterday, moodColor: .blue)
        let card2 = makeMoodCard(date: today, moodColor: .green)
        let card3 = makeMoodCard(date: twoDaysAgo, moodColor: .red)

        repository.cards = [card1, card2, card3].shuffled()

        await viewModel.fetchMoodCards()

        let sortedDates = viewModel.cards.map { $0.date }
        XCTAssertEqual(sortedDates, [today, yesterday, twoDaysAgo])
    }

    /// пустой список карточек приводит к состоянию .empty
    func testFetchMoodCards_withNoCards_shouldSetEmptyState() async {
        class MockStateDelegate: JournalListStateDelegate {
            var didCallEmpty = false
            func didChangeState(state: JournalListViewModel.State) {
                if case .empty = state {
                    didCallEmpty = true
                }
            }
        }

        let delegate = MockStateDelegate()
        viewModel.stateDelegate = delegate

        repository.cards = []

        await viewModel.fetchMoodCards()

        XCTAssertTrue(delegate.didCallEmpty)
    }

    /// успешная загрузка карточек вызывает состояние .loaded
    func testFetchMoodCards_withCards_shouldSetLoadedState() async {
        class MockStateDelegate: JournalListStateDelegate {
            var didCallLoaded = false
            func didChangeState(state: JournalListViewModel.State) {
                if case .loaded = state {
                    didCallLoaded = true
                }
            }
        }

        let delegate = MockStateDelegate()
        viewModel.stateDelegate = delegate

        repository.cards = [
            makeMoodCard(date: Date(), moodColor: .green)
        ]

        await viewModel.fetchMoodCards()

        XCTAssertTrue(delegate.didCallLoaded)
    }
}
