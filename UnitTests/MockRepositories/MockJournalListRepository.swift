//
//  MockJournalListRepository.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 24.05.2025.
//

import XCTest
@testable import MyEmotions

final class MockJournalListRepository: JournalListRepository {
    var cards: [MoodCard] = []
    var deletedCardIDs: [UUID] = []
    var savedCards: [MoodCard] = []

    func getMoodCards() async throws -> [MoodCard] {
        return cards.sorted { $0.date > $1.date }
    }

    func saveMoodCard(card: MoodCard) async throws {
        savedCards.append(card)
        cards.append(card)
    }

    func deleteMoodCard(id: UUID) async throws {
        deletedCardIDs.append(id)
        cards.removeAll { $0.id == id }
    }
}
