//
//  MockNoteAnswersRepository.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 24.05.2025.
//

import XCTest
@testable import MyEmotions

final class MockNoteAnswersRepository: NoteAnswersRepository {
    var storedAnswers: [String: [NoteAnswerItem]] = [:]

    func loadAnswers(for category: String) -> [NoteAnswerItem] {
        storedAnswers[category] ?? []
    }

    func saveAnswers(_ items: [NoteAnswerItem], for category: String) {
        storedAnswers[category] = items
    }

    func addCustomAnswer(_ title: String, to category: String) {
        var answers = storedAnswers[category] ?? []
        if !answers.contains(where: { $0.title == title }) {
            answers.append(NoteAnswerItem(title: title, isDefault: false))
        }
        storedAnswers[category] = answers
    }

    func deleteCustomAnswer(_ title: String, from category: String) {
        storedAnswers[category]?.removeAll { $0.title == title }
    }
}
