//
//  MoodMapper.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 05.05.2025.
//

import Foundation

extension MoodEntity {
    func toDomain() -> Mood? {
        guard
            let id        = self.id,
            let title     = self.title,
            let icon      = self.icon,
            let moodInfo  = self.moodInfo,
            let colorName = self.color,
            let colorType = MoodColorType(rawValue: colorName)
        else {
            return nil
        }
        return Mood(
            id:        id,
            title:     title,
            icon:      icon,
            moodInfo:  moodInfo,
            colorType: colorType
        )
    }
}
