//
//  StatisticsViewModel.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 14.05.2025.
//

import Foundation

protocol StatisticsViewModelDelegate: AnyObject {

}

final class StatisticsViewModel {

    // MARK: - Delegate
    weak var delegate: StatisticsViewModelDelegate?
    private let repository: StatisticsRepository
    private(set) var weeks: [StatWeek] = []
    private var loadedWeekStats: [DateInterval: WeekStatistic] = [:]

    // MARK: - Init
    init(repository: StatisticsRepository) {
        self.repository = repository
    }

    // MARK: - Actions
    func loadWeeks() {
        let intervals = repository.fetchWeeks()

        self.weeks = intervals.enumerated().map { index, interval in
            StatWeek(
                id: index,
                week: DateIntervalFormatter.formatWeekInterval(interval),
                interval: interval,
                data: nil
            )
        }
    }

    func loadStatistics(for interval: DateInterval) -> WeekStatistic {
        let data = repository.loadStatistics(for: interval)
        loadedWeekStats[interval] = data
        return data
    }
}
