//
//  NoteAnswersRepositoryImpl.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 19.05.2025.
//

import Foundation

final class NoteAnswersRepositoryImpl: NoteAnswersRepository {

    private let defaults = UserDefaults.standard

    private func key(for category: String) -> String {
        return "NoteAnswers_\(category)"
    }

    private let defaultValues: [String: [NoteAnswerItem]] = [
        "activities": [
            .init(title: "Приём пищи", isDefault: true),
            .init(title: "Встреча с друзьями", isDefault: true),
            .init(title: "Тренировка", isDefault: true),
            .init(title: "Хобби", isDefault: true),
            .init(title: "Отдых", isDefault: true),
            .init(title: "Поездка", isDefault: true)
        ],
        "people": [
            .init(title: "Один", isDefault: true),
            .init(title: "Друзья", isDefault: true),
            .init(title: "Семья", isDefault: true),
            .init(title: "Коллеги", isDefault: true),
            .init(title: "Партнёр", isDefault: true),
            .init(title: "Питомцы", isDefault: true)
        ],
        "places": [
            .init(title: "Дом", isDefault: true),
            .init(title: "Работа", isDefault: true),
            .init(title: "Школа", isDefault: true),
            .init(title: "Транспорт", isDefault: true),
            .init(title: "Улица", isDefault: true)
        ]
    ]

    func loadAnswers(for category: String) -> [NoteAnswerItem] {
        if let data = defaults.data(forKey: key(for: category)),
           let items = try? JSONDecoder().decode([NoteAnswerItem].self, from: data) {
            return items
        }

        let defaultsForCategory = defaultValues[category] ?? []
        saveAnswers(defaultsForCategory, for: category)
        return defaultsForCategory
    }

    func saveAnswers(_ items: [NoteAnswerItem], for category: String) {
        guard let data = try? JSONEncoder().encode(items) else { return }
        defaults.set(data, forKey: key(for: category))
    }

    func addCustomAnswer(_ title: String, to category: String) {
        var items = loadAnswers(for: category)
        guard !items.contains(where: { $0.title.caseInsensitiveCompare(title) == .orderedSame }) else { return }
        items.append(NoteAnswerItem(title: title, isDefault: false))
        saveAnswers(items, for: category)
    }

    func deleteCustomAnswer(_ title: String, from category: String) {
        var items = loadAnswers(for: category)
        items.removeAll { $0.title == title && $0.isDefault == false }
        saveAnswers(items, for: category)
    }
}
