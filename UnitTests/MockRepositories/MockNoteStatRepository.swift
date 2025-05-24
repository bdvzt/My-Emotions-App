//
//  MockNoteStatRepository.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 24.05.2025.
//

import XCTest
@testable import MyEmotions

final class MockNoteStatRepository: NoteStatRepository {
    var updatedGoal: Int?

    func loadStatistics() -> NoteStatistics {
        return NoteStatistics(
            totalCount: 10,
            dailyGoal: 3,
            streak: 2,
            circleStatistics: CircleStatistics(
                goalPercent: 1.0,
                bluePercent: 0.2,
                greenPercent: 0.3,
                redPercent: 0.3,
                orangePercent: 0.2
            )
        )
    }

    func updateGoal(_ newGoal: Int) {
        updatedGoal = newGoal
    }
}
