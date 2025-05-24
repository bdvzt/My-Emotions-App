//
//  Mood.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 05.05.2025.
//

import Foundation
import UIKit

struct Mood: Identifiable {
    let id: UUID
    let title: String
    let icon: String
    let moodInfo: String
    let colorType: MoodColorType

    var uiColor: UIColor { colorType.uiColor }
}

extension Mood {
    init?(entity: MoodEntity) {
        guard
            let id        = entity.id,
            let title     = entity.title,
            let icon      = entity.icon,
            let moodInfo  = entity.moodInfo,
            let colorName = entity.color,
                let colorType = MoodColorType(rawValue: colorName)
        else {
            return nil
        }
        self.id        = id
        self.title     = title
        self.icon      = icon
        self.moodInfo  = moodInfo
        self.colorType = colorType
    }
}

enum MoodColorType: String, CaseIterable, Codable {
    case red
    case orange
    case blue
    case green

    var uiColor: UIColor {
        switch self {
        case .red:    return .moodRed
        case .orange: return .moodOrange
        case .blue:   return .moodBlue
        case .green:  return .moodGreen
        }
    }
}
