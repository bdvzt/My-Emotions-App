//
//  AddNoteViewModel.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 10.05.2025.
//

import Foundation

protocol AddNoteViewModelDelegate: AnyObject {
    func didSaveNote()
}

final class AddNoteViewModel {
    // MARK: - Delegate
    weak var delegate: AddNoteViewModelDelegate?

    // MARK: - Dependencies
    private let repository: JournalListRepository
    private let selectedMood: Mood
    var mood: Mood { selectedMood }

    // MARK: - State
    private(set) var activities: [String] = []
    private(set) var people: [String] = []
    private(set) var places: [String] = []

    init(
        selectedMood: Mood,
        repository: JournalListRepository
    ) {
        self.selectedMood = selectedMood
        self.repository = repository
    }

    // MARK: - Inputs
    func updateActivities(_ items: [String]) {
        activities = items
    }

    func updatePeople(_ items: [String]) {
        people = items
    }

    func updatePlaces(_ items: [String]) {
        places = items
    }

    // MARK: - Saving
    func saveNote() async {
        let card = MoodCard(
            id: UUID(),
            date: Date(),
            mood: selectedMood,
            activities: activities,
            people: people,
            places: places
        )

        do {
            try await repository.saveMoodCard(card: card)
        } catch {
            print("NE POLUCHILOS SOCHRANIT")
        }
        delegate?.didSaveNote()
    }
}
