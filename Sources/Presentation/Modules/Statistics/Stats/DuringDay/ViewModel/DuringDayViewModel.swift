//
//  DuringDayViewModel.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 15.05.2025.
//

final class PartOfDayStatisticsViewModel {

    // MARK: - Properties

    let partsOfDay: [(colors: [PartOdDayColor], title: String)]

    // MARK: - Init

    init(data: PartsOfDayData) {
        self.partsOfDay = [
            (data.earlyMorning, "Раннее утро"),
            (data.morning, "Утро"),
            (data.day, "День"),
            (data.evening, "Вечер"),
            (data.lateEvening, "Поздний вечер")
        ]
    }
}
