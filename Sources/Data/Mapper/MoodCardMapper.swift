//
//  MoodCardMapper.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 05.05.2025.
//

import Foundation

extension MoodCardEntity {
    func toDomain(with mood: Mood) -> MoodCard? {
        guard let id = id,
              let date = dateAndTime else {
            return nil
        }

        return MoodCard(
            id: id,
            date: date,
            mood: mood,
            activities: activities ?? [],
            people: people ?? [],
            places: places ?? []
        )
    }
}
