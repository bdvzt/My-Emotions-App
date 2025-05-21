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
    private let noteAnswersRepository: NoteAnswersRepository
    private let selectedMood: Mood
    var mood: Mood { selectedMood }

    let activitiesViewModel: NoteAnswersViewModel
    let peopleViewModel: NoteAnswersViewModel
    let placesViewModel: NoteAnswersViewModel

    let existingCard: MoodCard?

    // MARK: - Init
    init(selectedMood: Mood,
         repository: JournalListRepository,
         noteAnswersRepository: NoteAnswersRepository,
         existingCard: MoodCard? = nil
    ) {
        self.selectedMood = selectedMood
        self.repository = repository
        self.noteAnswersRepository = noteAnswersRepository
        self.existingCard = existingCard

        self.activitiesViewModel = NoteAnswersViewModel(repository: noteAnswersRepository, category: "activities")
        self.peopleViewModel = NoteAnswersViewModel(repository: noteAnswersRepository, category: "people")
        self.placesViewModel = NoteAnswersViewModel(repository: noteAnswersRepository, category: "places")

        if let card = existingCard {
            self.activitiesViewModel.setSelectedAnswers(card.activities)
            self.peopleViewModel.setSelectedAnswers(card.people)
            self.placesViewModel.setSelectedAnswers(card.places)
        }
    }

    // MARK: - Saving
    func saveNote() async {
        let card = MoodCard(
            id: existingCard?.id ?? UUID(),
            date: existingCard?.date ?? Date(),
            mood: selectedMood,
            activities: activitiesViewModel.selectedAnswers,
            people: peopleViewModel.selectedAnswers,
            places: placesViewModel.selectedAnswers
        )

        do {
            try await repository.saveMoodCard(card: card)
            print(activitiesViewModel.selectedAnswers)
            print(peopleViewModel.selectedAnswers)
            print(placesViewModel.selectedAnswers)
        } catch {
            print("Не получилось сохранить")
        }

        delegate?.didSaveNote()
    }
}
