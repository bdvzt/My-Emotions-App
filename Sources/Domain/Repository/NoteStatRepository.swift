//
//  NoteStatRepository.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 20.05.2025.
//

import Foundation

protocol NoteStatRepository {
    func loadStatistics() -> NoteStatistics
    func updateGoal(_ newGoal: Int)
}
