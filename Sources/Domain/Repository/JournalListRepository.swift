//
//  JournalListRepository.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 05.05.2025.
//

import Foundation

protocol JournalListRepository {
    func getMoodCards() async throws -> [MoodCard]
    func saveMoodCard(card: MoodCard) async throws
    func deleteMoodCard(id: UUID) async throws
}
