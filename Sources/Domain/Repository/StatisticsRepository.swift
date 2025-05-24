//
//  StatisticsRepository.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 14.05.2025.
//

import Foundation

protocol StatisticsRepository {
    func fetchWeeks() -> [DateInterval]
    func fetchCards(for week: DateInterval) -> [MoodCardEntity]

    func categoryStatistics(for week: DateInterval) -> CategoryData
    func weekDaysStatistics(for week: DateInterval) -> [DayData]
    func frequencyStatistics(for week: DateInterval) -> [FrequencyData]
    func duringDayStatistics(for week: DateInterval) -> PartsOfDayData

    func loadStatistics(for week: DateInterval) -> WeekStatistic
}
