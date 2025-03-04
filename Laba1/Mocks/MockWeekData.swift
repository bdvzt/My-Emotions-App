//
//  MockWeekData.swift
//  LAB1
//
//  Created by Zayata Budaeva on 02.03.2025.
//

import UIKit

struct MockWeekData {
    static func emptyWeek() -> StatWeek {
        return StatWeek(
            week: "24 фев - 1 мар",
            data: WeekStatistic(
                redPercent: 0,
                bluePercent: 0,
                greenPercent: 0,
                orangePercent: 0,
                amountOfNotes: 0,

                dayData: [],
                frequencyData: [],
                partsOfDayStatistic: PartsOfDayStatistic(
                    earlyMorning: [],
                    morning: [],
                    day: [],
                    evening: [],
                    lateEvening: []
                )
            )
        )
    }

    static func lightWeek() -> StatWeek {
        return StatWeek(
            week: "17-23 фев",
            data: WeekStatistic(
                redPercent: 20,
                bluePercent: 30,
                greenPercent: 50,
                orangePercent: 0,
                amountOfNotes: 3,

                dayData: [
                    DayData(
                        day: "Понедельник",
                        date: "17 фев",
                        moodsTitles: ["Спокойствие"],
                        moodsImages: [.greenMood]
                    ),
                    DayData(
                        day: "Среда",
                        date: "19 фев",
                        moodsTitles: ["Выгорание"],
                        moodsImages: [.sadness]
                    ),
                    DayData(
                        day: "Суббота",
                        date: "22 фев",
                        moodsTitles: ["Продуктивность"],
                        moodsImages: [.lightning]
                    )
                ],

                frequencyData: [
                    FrequencyData(
                        image: .greenMood,
                        emotion: "Спокойствие",
                        amount: 1,
                        firstColor: .feelingGradientGreen,
                        secondColor: .greenGradient
                    ),
                    FrequencyData(
                        image: .sadness,
                        emotion: "Выгорание",
                        amount: 1,
                        firstColor: .feelingGradientRed,
                        secondColor: .redGradient
                    ),
                    FrequencyData(
                        image: .lightning,
                        emotion: "Продуктивность",
                        amount: 1,
                        firstColor: .feelingGradientOrange,
                        secondColor: .orangeGradient
                    )
                ],

                partsOfDayStatistic: PartsOfDayStatistic(
                    earlyMorning: [],
                    morning: [PartOdDayColor(color: .green, percentage: 100)],
                    day: [],
                    evening: [PartOdDayColor(color: .red, percentage: 100)],
                    lateEvening: []
                )
            )
        )
    }

    static func fullWeek() -> StatWeek {
        return StatWeek(
            week: "10-16 фев",
            data: WeekStatistic(
                redPercent: 50,
                bluePercent: 30,
                greenPercent: 20,
                orangePercent: 0,
                amountOfNotes: 10,

                dayData: [
                    DayData(
                        day: "Понедельник",
                        date: "10 фев",
                        moodsTitles: ["Спокойствие", "Радость"],
                        moodsImages: [.greenMood, .lightning]
                    ),
                    DayData(
                        day: "Вторник",
                        date: "11 фев",
                        moodsTitles: ["Выгорание", "Стресс"],
                        moodsImages: [.sadness, .lightning]
                    ),
                    DayData(
                        day: "Среда",
                        date: "12 фев",
                        moodsTitles: ["Продуктивность", "Радость"],
                        moodsImages: [.lightning, .lightning]
                    ),
                    DayData(
                        day: "Четверг",
                        date: "13 фев",
                        moodsTitles: ["Спокойствие", "Раздражение"],
                        moodsImages: [.greenMood, .sadness]
                    ),
                    DayData(
                        day: "Пятница",
                        date: "14 фев",
                        moodsTitles: ["Выгорание", "Спокойствие"],
                        moodsImages: [.sadness, .greenMood]
                    ),
                    DayData(
                        day: "Суббота",
                        date: "15 фев",
                        moodsTitles: ["Стресс", "Радость"],
                        moodsImages: [.sadness, .lightning]
                    ),
                    DayData(
                        day: "Воскресенье",
                        date: "16 фев",
                        moodsTitles: ["Спокойствие", "Усталость", "Радость", "Усталость", "Радость"],
                        moodsImages: [.greenMood, .shell, .lightning, .shell, .lightning]
                    )
                ],

                frequencyData: [
                    FrequencyData(
                        image: .lightning,
                        emotion: "Стресс",
                        amount: 3,
                        firstColor: .feelingGradientOrange,
                        secondColor: .orangeGradient
                    ),
                    FrequencyData(
                        image: .sadness,
                        emotion: "Выгорание",
                        amount: 2,
                        firstColor: .feelingGradientRed,
                        secondColor: .redGradient
                    ),
                    FrequencyData(
                        image: .greenMood,
                        emotion: "Спокойствие",
                        amount: 3,
                        firstColor: .feelingGradientGreen,
                        secondColor: .greenGradient
                    )
                ],

                partsOfDayStatistic: PartsOfDayStatistic(
                    earlyMorning: [PartOdDayColor(color: .red, percentage: 60)],
                    morning: [PartOdDayColor(color: .green, percentage: 80)],
                    day: [PartOdDayColor(color: .yellow, percentage: 30)],
                    evening: [PartOdDayColor(color: .red, percentage: 50)],
                    lateEvening: [PartOdDayColor(color: .blue, percentage: 10)]
                )
            )
        )
    }

    static func createMockWeeksData() -> [StatWeek] {
        return [emptyWeek(), lightWeek(), fullWeek()]
    }
}
