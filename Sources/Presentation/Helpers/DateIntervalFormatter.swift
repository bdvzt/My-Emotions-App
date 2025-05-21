//
//  DateIntervalFormatter.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 15.05.2025.
//

import Foundation

enum DateIntervalFormatter {
    static func formatWeekInterval(_ interval: DateInterval) -> String {
        let calendar = Calendar.current
        let start = interval.start
        let end = calendar.date(byAdding: .day, value: -1, to: interval.end) ?? interval.end

        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "ru_RU")
        dayFormatter.setLocalizedDateFormatFromTemplate("d")

        let monthFormatter = DateFormatter()
        monthFormatter.locale = Locale(identifier: "ru_RU")
        monthFormatter.setLocalizedDateFormatFromTemplate("MMM")

        let sameMonth = calendar.isDate(start, equalTo: end, toGranularity: .month)

        if sameMonth {
            let startDay = dayFormatter.string(from: start)
            let endDayWithMonth = "\(dayFormatter.string(from: end)) \(monthFormatter.string(from: end))"
            return "\(startDay)–\(endDayWithMonth)"
        } else {
            let fullStart = "\(dayFormatter.string(from: start)) \(monthFormatter.string(from: start))"
            let fullEnd = "\(dayFormatter.string(from: end)) \(monthFormatter.string(from: end))"
            return "\(fullStart)–\(fullEnd)"
        }
    }
}

extension Date {
    func formattedForMoodCard(locale: Locale = Locale(identifier: "ru_RU")) -> String {
        let calendar = Calendar.current
        let now = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = locale

        let time = timeFormatter.string(from: self)

        if calendar.isDateInToday(self) {
            return "сегодня, \(time)"
        } else if calendar.isDateInYesterday(self) {
            return "вчера, \(time)"
        } else if calendar.isDate(self, equalTo: now, toGranularity: .weekOfYear) {
            let weekdayFormatter = DateFormatter()
            weekdayFormatter.locale = locale
            weekdayFormatter.dateFormat = "EEEE"
            let weekday = weekdayFormatter.string(from: self)
            return "\(weekday), \(time)"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = locale
            dateFormatter.dateFormat = "d MMMM"
            let date = dateFormatter.string(from: self)
            return "\(date), \(time)"
        }
    }
}
