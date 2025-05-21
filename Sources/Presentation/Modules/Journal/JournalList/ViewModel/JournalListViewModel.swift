//
//  JournalListViewModel.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 01.05.2025.
//

import Foundation

protocol JournalListViewModelDelegate: AnyObject {
    func didRequestAddMood()
    func didSelectMoodCard(_ card: MoodCard)
}

protocol JournalListStateDelegate: AnyObject {
    func didChangeState(state: JournalListViewModel.State)
}

final class JournalListViewModel {

    // MARK: - Properties
    weak var navigationDelegate: JournalListViewModelDelegate?
    weak var stateDelegate: JournalListStateDelegate?

    private let repository: JournalListRepository
    private let statRepository: NoteStatRepository
    private(set) var moodCards: [MoodCardViewModel] = []
    private(set) var cards: [MoodCard] = []

    // MARK: - Init
    init(repository: JournalListRepository, statRepository: NoteStatRepository) {
        self.repository = repository
        self.statRepository = statRepository
    }

    // MARK: - Actions
    func didTapAddMood() {
        navigationDelegate?.didRequestAddMood()
    }

    func didTapCard(with id: UUID) {
        guard let card = cards.first(where: { $0.id == id }) else { return }
        navigationDelegate?.didSelectMoodCard(card)
    }

    func updateDailyGoal(_ newGoal: Int) {
        statRepository.updateGoal(newGoal)
    }

    // MARK: - Data fetching
    @MainActor
    func fetchMoodCards() async {
        stateDelegate?.didChangeState(state: .loading)

        do {
            let domainCards = try await repository.getMoodCards()

            self.cards = domainCards
            self.moodCards = domainCards.map { domainCard in
                MoodCardViewModel(from: domainCard)
            }

            if self.moodCards.isEmpty {
                stateDelegate?.didChangeState(state: .empty)
            } else {
                stateDelegate?.didChangeState(state: .loaded(self.moodCards))
            }
        } catch {
            stateDelegate?.didChangeState(state: .error(error.localizedDescription))
        }
    }

    func deleteCard(with id: UUID) async {
        do {
            try await repository.deleteMoodCard(id: id)
            await fetchMoodCards()
        } catch {
            print("Ошибка при удалении карточки: \(error)")
        }
    }

    @MainActor
    func getNoteStatistics() -> NoteStatistics {
        statRepository.loadStatistics()
    }
}
