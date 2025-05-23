//
//  StatisticsRepositoryImpl.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 14.05.2025.
//

import Foundation
import CoreData
import UIKit

final class StatisticsRepositoryImpl: StatisticsRepository {

    // MARK: - Dependencies
    private let context: NSManagedObjectContext

    // MARK: - Init
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Fetch weeks & cards
    func fetchWeeks() -> [DateInterval] {
        let calendar = Calendar.current
        let now = Date()
        var weeks: [DateInterval] = []

        guard var currentWeek = calendar.dateInterval(of: .weekOfYear, for: now) else {
            return []
        }

        for _ in 0..<52 {
            weeks.append(currentWeek)

            guard let previousWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: currentWeek.start),
                  let previousWeek = calendar.dateInterval(of: .weekOfYear, for: previousWeekStart) else {
                break
            }

            currentWeek = previousWeek
        }

        return weeks
    }

    func fetchCards(for week: DateInterval) -> [MoodCardEntity] {
        let request = NSFetchRequest<MoodCardEntity>(entityName: "MoodCardEntity")

        request.predicate = NSPredicate(
            format: "dateAndTime >= %@ AND dateAndTime < %@",
            week.start as NSDate,
            week.end as NSDate
        )

        request.sortDescriptors = [NSSortDescriptor(key: "dateAndTime", ascending: true)]

        do {
            return try context.fetch(request)
        } catch {
            print("ошибка при fetchCards(for:):", error)
            return []
        }
    }

    // MARK: - Total statistics
    func loadStatistics(for week: DateInterval) -> WeekStatistic {
        return WeekStatistic(
            categoryData: categoryStatistics(for: week),
            dayData: weekDaysStatistics(for: week),
            frequencyData: frequencyStatistics(for: week),
            partsOfDayData: duringDayStatistics(for: week)
        )
    }

    // MARK: - Category Statistics
    func categoryStatistics(for week: DateInterval) -> CategoryData {
        let cards = fetchCards(for: week)

        let total = cards.count
        guard total > 0 else {
            return CategoryData(amountOfNotes: 0, redPercent: 0, bluePercent: 0, greenPercent: 0, orangePercent: 0)
        }

        var red = 0
        var blue = 0
        var green = 0
        var orange = 0

        for card in cards {
            guard let color = card.mood?.color?.lowercased() else { continue }

            switch color {
            case "red":
                red += 1
            case "blue":
                blue += 1
            case "green":
                green += 1
            case "orange":
                orange += 1
            default:
                break
            }
        }

        func percent(_ count: Int) -> Int {
            Int((Double(count) / Double(total)) * 100)
        }

        return CategoryData(
            amountOfNotes: total,
            redPercent: percent(red),
            bluePercent: percent(blue),
            greenPercent: percent(green),
            orangePercent: percent(orange)
        )
    }

    // MARK: - Days statistics
    func weekDaysStatistics(for week: DateInterval) -> [DayData] {
        let cards = fetchCards(for: week)

        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ru_RU")
        calendar.firstWeekday = 2

        let locale = calendar.locale ?? Locale(identifier: "ru_RU")

        let grouped = Dictionary(grouping: cards) { card in
            guard let date = card.dateAndTime else { return Date.distantPast }
            return calendar.startOfDay(for: date)
        }

        let dayFormatter = DateFormatter()
        dayFormatter.locale = locale
        dayFormatter.dateFormat = "EEEE"

        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.setLocalizedDateFormatFromTemplate("d MMM")

        var result: [DayData] = []

        for i in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: i, to: week.start) else { continue }

            let dayName = dayFormatter.string(from: date).capitalized
            let dateString = dateFormatter.string(from: date)

            let dailyCards = grouped[calendar.startOfDay(for: date)] ?? []

            var moodTitlesSet = Set<String>()
            var moodImages: [UIImage] = []

            for card in dailyCards {
                guard let mood = card.mood,
                      let title = mood.title,
                      !moodTitlesSet.contains(title),
                      let iconName = mood.icon,
                      let image = UIImage(named: iconName) else { continue }

                moodTitlesSet.insert(title)
                moodImages.append(image)
            }

            result.append(DayData(
                day: dayName,
                date: dateString,
                moodsTitles: Array(moodTitlesSet),
                moodsImages: moodImages
            ))
        }

        return result
    }

    // MARK: - Frequency statistics
    func frequencyStatistics(for week: DateInterval) -> [FrequencyData] {
        let cards = fetchCards(for: week)

        var frequencyDict: [String: (count: Int, icon: String?, color: String?)] = [:]

        for card in cards {
            guard let mood = card.mood,
                  let title = mood.title else { continue }

            if frequencyDict[title] != nil {
                frequencyDict[title]?.count += 1
            } else {
                frequencyDict[title] = (
                    count: 1,
                    icon: mood.icon,
                    color: mood.color
                )
            }
        }

        let sorted = frequencyDict.sorted { $0.value.count > $1.value.count }

        let result = sorted.compactMap { (title, value) -> FrequencyData? in
            guard let iconName = value.icon,
                  let image = UIImage(named: iconName),
                  let colorName = value.color else { return nil }

            let (firstColor, secondColor): (UIColor, UIColor)

            switch colorName.lowercased() {
            case "red":
                firstColor = .redGradient
                secondColor = .feelingGradientRed
            case "blue":
                firstColor = .blueGradient
                secondColor = .feelingGradientBlue
            case "green":
                firstColor = .greenGradient
                secondColor = .feelingGradientGreen
            case "orange":
                firstColor = .orangeGradient
                secondColor = .feelingGradientOrange
            default:
                firstColor = .gray
                secondColor = .lightGray
            }

            return FrequencyData(
                image: image,
                emotion: title,
                amount: value.count,
                firstColor: firstColor,
                secondColor: secondColor
            )
        }

        return result
    }

    // MARK: - Parts of day
    func duringDayStatistics(for week: DateInterval) -> PartsOfDayData {
        let cards = fetchCards(for: week)

        var parts: [String: [String]] = [
            "earlyMorning": [],
            "morning": [],
            "day": [],
            "evening": [],
            "lateEvening": []
        ]

        let calendar = Calendar.current

        for card in cards {
            guard let date = card.dateAndTime,
                  let color = card.mood?.color?.lowercased() else { continue }

            let hour = calendar.component(.hour, from: date)

            switch hour {
            case 5...8:
                parts["earlyMorning"]?.append(color)
            case 9...11:
                parts["morning"]?.append(color)
            case 12...16:
                parts["day"]?.append(color)
            case 17...20:
                parts["evening"]?.append(color)
            default:
                parts["lateEvening"]?.append(color)
            }
        }

        func makeStat(from colors: [String]) -> PartOfDayStat {
            let total = colors.count
            if total == 0 {
                return PartOfDayStat(colors: [], amount: 0)
            }

            let grouped = Dictionary(grouping: colors) { $0 }
            let colorStats = grouped.map { (colorName, group) in
                let percent = Int((Double(group.count) / Double(total)) * 100)
                return PartOdDayColor(color: mapColor(colorName), percentage: percent)
            }.sorted { $0.percentage > $1.percentage }

            return PartOfDayStat(colors: colorStats, amount: total)
        }

        func mapColor(_ name: String) -> EmotionColor {
            switch name {
            case "red": return .red
            case "blue": return .blue
            case "green": return .green
            case "orange": return .orange
            default: return .none
            }
        }

        return PartsOfDayData(
            earlyMorning: makeStat(from: parts["earlyMorning"] ?? []),
            morning: makeStat(from: parts["morning"] ?? []),
            day: makeStat(from: parts["day"] ?? []),
            evening: makeStat(from: parts["evening"] ?? []),
            lateEvening: makeStat(from: parts["lateEvening"] ?? [])
        )
    }
}
