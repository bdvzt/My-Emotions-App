//
//  NoteStatistics.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 20.05.2025.
//

import Foundation

struct NoteStatistics: Codable {
    var totalCount: Int
    var dailyGoal: Int
    var streak: Int

    var circleStatistics: CircleStatistics
}
