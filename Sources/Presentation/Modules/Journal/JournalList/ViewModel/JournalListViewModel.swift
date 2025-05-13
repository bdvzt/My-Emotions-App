//
//  JournalListViewModel.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 01.05.2025.
//

protocol JournalListViewModelDelegate: AnyObject {
    func didRequestAddMood()
}

protocol JournalListStateDelegate: AnyObject {
    func didChangeState(state: JournalListViewModel.State)
}

final class JournalListViewModel {

    // MARK: - Properties
    weak var navigationDelegate: JournalListViewModelDelegate?
    weak var stateDelegate: JournalListStateDelegate?

    private let repository: JournalListRepository
    private(set) var moodCards: [MoodCardViewModel] = []

    // MARK: - Init
    init(repository: JournalListRepository) {
        self.repository = repository
    }

    // MARK: - Actions
    func didTapAddMood() {
        navigationDelegate?.didRequestAddMood()
    }

    // MARK: - Data fetching
    @MainActor
    func fetchMoodCards() async {
        stateDelegate?.didChangeState(state: .loading)

        do {
            let domainCards = try await repository.getMoodCards()

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
}
