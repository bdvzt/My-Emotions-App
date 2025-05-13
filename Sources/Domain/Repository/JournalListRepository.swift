//
//  JournalListRepository.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 05.05.2025.
//

protocol JournalListRepository {
    func getMoodCards() async throws -> [MoodCard]
    func saveMoodCard(card: MoodCard) async throws
}
