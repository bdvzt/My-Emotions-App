//
//  NoteAnswerItem.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 19.05.2025.
//

import Foundation

struct NoteAnswerItem: Codable, Equatable {
    let title: String
    let isDefault: Bool

    static func == (lhs: NoteAnswerItem, rhs: NoteAnswerItem) -> Bool {
        return lhs.title == rhs.title
    }
}
