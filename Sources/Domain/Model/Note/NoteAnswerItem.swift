//
//  NoteAnswerItem.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 19.05.2025.
//

import Foundation

struct NoteAnswerItem: Codable, Identifiable {
    let id: UUID
    let title: String
    let isDefault: Bool
}

// MARK: - Equatable по title
extension NoteAnswerItem: Equatable {
    static func == (lhs: NoteAnswerItem, rhs: NoteAnswerItem) -> Bool {
        return lhs.title.caseInsensitiveCompare(rhs.title) == .orderedSame
    }
}
