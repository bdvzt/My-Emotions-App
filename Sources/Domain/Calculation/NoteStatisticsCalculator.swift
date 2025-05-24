//
//  NoteStatisticsCalculator.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 24.05.2025.
//

import Foundation

struct NoteStatisticsCalculator {
    static func calculate(from cards: [MoodCard], dailyGoal: Int) -> NoteStatistics {
        let totalCount = cards.count
        let today = Date().startOfDay
        let todayCards = cards.filter { $0.date.startOfDay == today }

        var blue = 0, green = 0, red = 0, orange = 0

        for card in todayCards {
            switch card.mood.colorType {
            case .blue: blue += 1
            case .green: green += 1
            case .red: red += 1
            case .orange: orange += 1
            }
        }

        let todayCount = todayCards.count
        let goalPercent = min(Double(todayCount) / Double(dailyGoal), 1.0)

        let circleStats = CircleStatistics(
            goalPercent: goalPercent,
            bluePercent: todayCount > 0 ? Double(blue) / Double(todayCount) : 0,
            greenPercent: todayCount > 0 ? Double(green) / Double(todayCount) : 0,
            redPercent: todayCount > 0 ? Double(red) / Double(todayCount) : 0,
            orangePercent: todayCount > 0 ? Double(orange) / Double(todayCount) : 0
        )

        let latestDate = Date().startOfDay

        let streak = calculateStreak(from: cards, latestDate: latestDate, dailyGoal: dailyGoal)

        return NoteStatistics(
            totalCount: totalCount,
            dailyGoal: dailyGoal,
            streak: streak,
            circleStatistics: circleStats
        )
    }

    private static func calculateStreak(from cards: [MoodCard], latestDate: Date, dailyGoal: Int) -> Int {
        var streak = 0
        var currentDate = latestDate
        let calendar = Calendar.current

        let groupedByDay = Dictionary(grouping: cards, by: { $0.date.startOfDay })

        while true {
            let entries = groupedByDay[currentDate] ?? []
            if entries.count >= dailyGoal {
                streak += 1
                guard let previous = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
                currentDate = previous
            } else {
                break
            }
        }

        return streak
    }
}

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
