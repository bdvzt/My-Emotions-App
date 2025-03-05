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
            week: "10-16 фев",
            data: WeekStatistic(
                redPercent: 0,
                bluePercent: 0,
                greenPercent: 0,
                orangePercent: 0,
                amountOfNotes: 0,

                dayData: [
                    DayData(day: "Понедельник", date: "10 фев", moodsTitles: [], moodsImages: []),
                    DayData(day: "Вторник", date: "11 фев", moodsTitles: [], moodsImages: []),
                    DayData(day: "Среда", date: "12 фев", moodsTitles: [], moodsImages: []),
                    DayData(day: "Четверг", date: "13 фев", moodsTitles: [], moodsImages: []),
                    DayData(day: "Пятница", date: "14 фев", moodsTitles: [], moodsImages: []),
                    DayData(day: "Суббота", date: "15 фев", moodsTitles: [], moodsImages: []),
                    DayData(day: "Воскресенье", date: "16 фев", moodsTitles: [], moodsImages: [])
                ],
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
            week: "3-9 фев",
            data: WeekStatistic(
                redPercent: 40,
                bluePercent: 40,
                greenPercent: 20,
                orangePercent: 0,
                amountOfNotes: 3,

                dayData: [
                    DayData(day: "Понедельник", date: "3 фев", moodsTitles: ["Спокойствие"], moodsImages: [.greenMood]),
                    DayData(day: "Вторник", date: "4 фев", moodsTitles: [], moodsImages: []),
                    DayData(day: "Среда", date: "5 фев", moodsTitles: ["Выгорание"], moodsImages: [.sadness]),
                    DayData(day: "Четверг", date: "6 фев", moodsTitles: [], moodsImages: []),
                    DayData(day: "Пятница", date: "7 фев", moodsTitles: [], moodsImages: []),
                    DayData(day: "Суббота", date: "8 фев", moodsTitles: ["Продуктивность"], moodsImages: [.lightning]),
                    DayData(day: "Воскресенье", date: "9 фев", moodsTitles: [], moodsImages: [])
                ],

                frequencyData: [
                    FrequencyData(image: .greenMood, emotion: "Спокойствие", amount: 1, firstColor: .feelingGradientGreen, secondColor: .greenGradient),
                    FrequencyData(image: .sadness, emotion: "Выгорание", amount: 1, firstColor: .feelingGradientRed, secondColor: .redGradient),
                    FrequencyData(image: .lightning, emotion: "Продуктивность", amount: 1, firstColor: .feelingGradientOrange, secondColor: .orangeGradient)
                ],

                partsOfDayStatistic: PartsOfDayStatistic(
                    earlyMorning: [],
                    morning: [PartOdDayColor(color: .green, percentage: 1)],
                    day: [],
                    evening: [PartOdDayColor(color: .red, percentage: 1)],
                    lateEvening: []
                )
            )
        )
    }

    static func fullWeek() -> StatWeek {
        return StatWeek(
            week: "17-23 фев",
            data: WeekStatistic(
                redPercent: 60,
                bluePercent: 40,
                greenPercent: 0,
                orangePercent: 0,
                amountOfNotes: 10,

                dayData: [
                    DayData(day: "Понедельник", date: "17 фев", moodsTitles: ["Спокойствие", "Радость"], moodsImages: [.greenMood, .lightning]),
                    DayData(day: "Вторник", date: "18 фев", moodsTitles: ["Выгорание", "Стресс"], moodsImages: [.sadness, .lightning]),
                    DayData(day: "Среда", date: "19 фев", moodsTitles: ["Продуктивность", "Радость"], moodsImages: [.lightning, .lightning]),
                    DayData(day: "Четверг", date: "20 фев", moodsTitles: ["Спокойствие", "Раздражение"], moodsImages: [.greenMood, .sadness]),
                    DayData(day: "Пятница", date: "21 фев", moodsTitles: ["Выгорание", "Спокойствие"], moodsImages: [.sadness, .greenMood]),
                    DayData(day: "Суббота", date: "22 фев", moodsTitles: ["Стресс", "Радость"], moodsImages: [.sadness, .lightning]),
                    DayData(day: "Воскресенье", date: "23 фев", moodsTitles: ["Спокойствие", "Усталость", "Радость"], moodsImages: [.greenMood, .shell, .lightning])
                ],

                frequencyData: [
                    FrequencyData(image: .lightning, emotion: "Стресс", amount: 3, firstColor: .feelingGradientOrange, secondColor: .orangeGradient),
                    FrequencyData(image: .sadness, emotion: "Выгорание", amount: 2, firstColor: .feelingGradientRed, secondColor: .redGradient),
                    FrequencyData(image: .greenMood, emotion: "Спокойствие", amount: 3, firstColor: .feelingGradientGreen, secondColor: .greenGradient)
                ],

                partsOfDayStatistic: PartsOfDayStatistic(
                    earlyMorning: [PartOdDayColor(color: .red, percentage: 100)],
                    morning: [PartOdDayColor(color: .green, percentage: 100)],
                    day: [PartOdDayColor(color: .yellow, percentage: 100)],
                    evening: [PartOdDayColor(color: .red, percentage: 100)],
                    lateEvening: [PartOdDayColor(color: .blue, percentage: 100)]
                )
            )
        )
    }

    static func anotherWeek() -> StatWeek {
        return StatWeek(
            week: "27 янв - 2 фев",
            data: WeekStatistic(
                redPercent: 40,
                bluePercent: 30,
                greenPercent: 30,
                orangePercent: 0,
                amountOfNotes: 10,

                dayData: [
                    DayData(day: "Понедельник", date: "27 янв", moodsTitles: [], moodsImages: []),
                    DayData(day: "Вторник", date: "28 янв", moodsTitles: [], moodsImages: []),
                    DayData(day: "Среда", date: "29 янв", moodsTitles: [], moodsImages: []),
                    DayData(day: "Четверг", date: "30 янв", moodsTitles: [], moodsImages: []),
                    DayData(day: "Пятница", date: "31 янв", moodsTitles: [], moodsImages: []),
                    DayData(day: "Суббота", date: "1 фев", moodsTitles: [], moodsImages: []),
                    DayData(day: "Воскресенье", date: "2 фев", moodsTitles: [], moodsImages: [])
                ],

                frequencyData: [],

                partsOfDayStatistic: PartsOfDayStatistic(
                    earlyMorning: [PartOdDayColor(color: .red, percentage: 100)],
                    morning: [PartOdDayColor(color: .green, percentage: 100)],
                    day: [PartOdDayColor(color: .yellow, percentage: 100)],
                    evening: [PartOdDayColor(color: .red, percentage: 100)],
                    lateEvening: [PartOdDayColor(color: .blue, percentage: 100)]
                )
            )
        )
    }

    static func createMockWeeksData() -> [StatWeek] {
        return [fullWeek(), emptyWeek(), lightWeek(), anotherWeek()]
    }
}
