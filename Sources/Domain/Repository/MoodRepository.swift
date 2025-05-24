//
//  MoodRepository.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 09.05.2025.
//

protocol MoodRepository {
    func fetchAll() -> [Mood]
    func setMoodsIfNeeded()
}
