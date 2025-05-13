//
//  MoodCard.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 02.05.2025.
//

import Foundation

struct MoodCard: Identifiable {
    let id: UUID
    let date: Date
    let mood: Mood
    let activities: [String]
    let people: [String]
    let places: [String]
}
