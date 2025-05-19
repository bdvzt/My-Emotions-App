//
//  NoteAnswersRepository.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 19.05.2025.
//

protocol NoteAnswersRepository {
    func loadAnswers(for category: String) -> [NoteAnswerItem]
    func saveAnswers(_ items: [NoteAnswerItem], for category: String)
    func addCustomAnswer(_ title: String, to category: String)
    func deleteCustomAnswer(_ title: String, from category: String)
}
