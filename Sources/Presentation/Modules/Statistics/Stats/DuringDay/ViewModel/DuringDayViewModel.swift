//
//  DuringDayViewModel.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 15.05.2025.
//

final class PartOfDayStatisticsViewModel {
    
    // MARK: - Properties
    
    let partsOfDay: [(colors: [PartOdDayColor], title: String, amount: Int)]
    
    // MARK: - Init
    
    init(data: PartsOfDayData) {
        self.partsOfDay = [
            (data.earlyMorning.colors, "Раннее утро", data.earlyMorning.amount),
            (data.morning.colors, "Утро", data.morning.amount),
            (data.day.colors, "День", data.day.amount),
            (data.evening.colors, "Вечер", data.evening.amount),
            (data.lateEvening.colors, "Поздний вечер", data.lateEvening.amount)
        ]
    }
}
