//
//  MoodCardViewModel.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 05.05.2025.
//

import UIKit

struct MoodCardViewModel {
    let id: UUID
    let dateString: String
    let moodTitle: String
    let moodColor: UIColor
    let moodIcon: UIImage?

    init(from moodCard: MoodCard) {
        self.id = moodCard.id
        self.dateString = DateFormatter.localizedString(from: moodCard.date, dateStyle: .medium, timeStyle: .short)
        self.moodTitle = moodCard.mood.title
        self.moodColor = moodCard.mood.colorType.uiColor
        self.moodIcon = UIImage(named: moodCard.mood.icon)
    }
}
