//
//  NoteStatRepositoryImpl.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 20.05.2025.
//

import Foundation
import CoreData

final class NoteStatRepositoryImpl: NoteStatRepository {
    private let context: NSManagedObjectContext
    private let goalKey = "daily_goal"

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func loadStatistics() -> NoteStatistics {
        do {
            let request: NSFetchRequest<MoodCardEntity> = MoodCardEntity.fetchRequest()
            let cards = try context.fetch(request)

            let totalCount = cards.count
            let rawGoal = UserDefaults.standard.integer(forKey: goalKey)
            let dailyGoal = rawGoal == 0 ? 1 : rawGoal

            let today = Date().startOfDay
            let todayCards = cards.filter { $0.dateAndTime?.startOfDay == today }

            var blue = 0, green = 0, red = 0, orange = 0

            for card in todayCards {
                let color = card.mood?.color ?? ""
                switch color.lowercased() {
                case "blue": blue += 1
                case "green": green += 1
                case "red": red += 1
                case "orange": orange += 1
                default: break
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

            let dates = cards.compactMap { $0.dateAndTime?.startOfDay }.sorted(by: >)
            let latestDate = dates.first ?? today

            let streak = calculateStreak(from: cards, latestDate: latestDate, dailyGoal: dailyGoal)

            return NoteStatistics(
                totalCount: totalCount,
                dailyGoal: dailyGoal,
                streak: streak,
                circleStatistics: circleStats
            )

        } catch {
            print("статистика записей не посчиталась, плаки-плаки: \(error)")
            return NoteStatistics(
                totalCount: 0,
                dailyGoal: 1,
                streak: 0,
                circleStatistics: CircleStatistics(goalPercent: 0, bluePercent: 0, greenPercent: 0, redPercent: 0, orangePercent: 0)
            )
        }
    }

    func updateGoal(_ newGoal: Int) {
        UserDefaults.standard.set(newGoal, forKey: goalKey)
    }

    private func calculateStreak(from cards: [MoodCardEntity], latestDate: Date, dailyGoal: Int) -> Int {
        var streak = 0
        var currentDate = latestDate
        let calendar = Calendar.current

        let groupedByDay: [Date: [MoodCardEntity]] = Dictionary(grouping: cards, by: {
            $0.dateAndTime.map { calendar.startOfDay(for: $0) } ?? .distantPast
        })

        while true {
            let entriesForDay = groupedByDay[currentDate] ?? []

            if entriesForDay.count >= dailyGoal {
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
