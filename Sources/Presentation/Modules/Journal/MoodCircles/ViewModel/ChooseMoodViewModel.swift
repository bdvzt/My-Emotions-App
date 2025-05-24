//
//  ChooseMoodViewModel.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 08.05.2025.
//

protocol ChooseMoodViewModelDelegate: AnyObject {
    func didChooseMood()
}

final class ChooseMoodViewModel {

    // MARK: - Delegate
    weak var delegate: ChooseMoodViewModelDelegate?
    private let journalListRepository: JournalListRepository
    private let moodRepository: MoodRepository

    private(set) var moods: [Mood] = []

    private(set) var selectedMood: Mood?

    // MARK: - Init
    init(
        journalListRepository: JournalListRepository,
        moodRepository: MoodRepository,
        preselectedMood: Mood? = nil
    ) {
        self.journalListRepository = journalListRepository
        self.moodRepository = moodRepository
        self.selectedMood = preselectedMood
        moodRepository.setMoodsIfNeeded()
        loadMoods()
    }

    private func loadMoods() {
        moods = moodRepository.fetchAll()
    }

    // MARK: - Actions
    func didTapMoodCircle(_ mood: Mood) {
        selectedMood = mood
    }
    func didTapArrow() {
        delegate?.didChooseMood()
    }
}
