//
//  NoteAnswersViewModel.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 19.05.2025.
//

import Foundation

final class NoteAnswersViewModel {
    private let repository: NoteAnswersRepository
    private let category: String

    private(set) var answers: [NoteAnswerItem] = []
    private(set) var selectedAnswers: [String] = []

    init(repository: NoteAnswersRepository, category: String) {
        self.repository = repository
        self.category = category
        self.load()
    }

    private func load() {
        self.answers = self.repository.loadAnswers(for: category)
    }

    func add(_ title: String) {
        self.repository.addCustomAnswer(title, to: category)

        let newItem = NoteAnswerItem(title: title, isDefault: false)
        self.answers.append(newItem)
    }

    func addAndSelect(_ title: String) {
        add(title)
        toggleAnswer(title: title)

    }

    func toggleAnswer(title: String) {
        if selectedAnswers.contains(title) {
            selectedAnswers.removeAll { $0 == title }
        } else {
            selectedAnswers.append(title)
        }
    }

    func setSelectedAnswers(_ answers: [String]) {
        self.selectedAnswers = answers
    }
}
