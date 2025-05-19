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

    @Published
    private(set) var answers: [NoteAnswerItem] = []

    @Published
    private(set) var selectedAnswers: [NoteAnswerItem] = []

    init(repository: NoteAnswersRepository, category: String) {
        self.repository = repository
        self.category = category
        self.load()
    }

    private func load() {
        self.answers = self.repository.loadAnswers(for: category)
    }

    private func add(_ title: String) {
        self.repository.addCustomAnswer(title, to: category)
        self.load()
    }

    private func delete(_ title: String) {
        self.repository.deleteCustomAnswer(title, from: category)
        self.load()
    }

    func toggleAnswer(answer: NoteAnswerItem) {
        if answers.contains(answer) {
            selectedAnswers.removeAll { $0 == answer }
        } else {
            selectedAnswers.append(answer)
        }
    }
}
