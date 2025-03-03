//
//  MockWeekData.swift
//  LAB1
//
//  Created by Zayata Budaeva on 02.03.2025.
//

import UIKit

func createMockWeeksData() -> [StatWeek] {
    return [
        StatWeek(
            week: "17-23 фев",
            data: WeekStatistic(
                redPercent: 60,
                bluePercent: 40,
                greenPercent: 0,
                orangePercent: 0,
                amountOfNotes: 10,

                dayData: [
                    DayData(
                        day: "Понедельник",
                        date: "17 фев",
                        moodsTitles: ["Спокойствие", "Продуктивность"],
                        moodsImages: [.greenMood, .lightning]
                    ),
                    DayData(
                        day: "Вторник",
                        date: "18 фев",
                        moodsTitles: ["Выгорание", "Усталость"],
                        moodsImages: [.sadness, .shell]
                    ),
                    DayData(
                        day: "Среда",
                        date: "19 фев",
                        moodsTitles: ["Выгорание", "Усталость"],
                        moodsImages: [.sadness, .shell]
                    ),
                    DayData(
                        day: "Четверг",
                        date: "20 фев",
                        moodsTitles: ["Выгорание", "Усталость"],
                        moodsImages: [.sadness, .shell]
                    ),
                    DayData(
                        day: "Пятница",
                        date: "21 фев",
                        moodsTitles: ["Выгорание", "Усталость"],
                        moodsImages: [.sadness, .shell]
                    ),
                    DayData(
                        day: "Суббота",
                        date: "22 фев",
                        moodsTitles: [],
                        moodsImages: []
                    ),
                    DayData(
                        day: "Воскресенье",
                        date: "23 фев",
                        moodsTitles: ["Выгорание", "Усталость"],
                        moodsImages: [.sadness, .shell]
                    )
                ],

                frequencyData: [
                    FrequencyData(
                        image: .sadness,
                        emotion: "Выгорание",
                        percentage: 70,
                        firstColor: .red,
                        secondColor: .orange
                    ),
                    FrequencyData(
                        image: .lightning,
                        emotion: "Продуктивность",
                        percentage: 30,
                        firstColor: .blue,
                        secondColor: .cyan
                    )
                ],
                partsOfDayStatistic: PartsOfDayStatistic(
                    earlyMorning: [
                        PartOdDayColor(color: .red, percentage: 60),
                        PartOdDayColor(color: .blue, percentage: 40)
                    ],
                    morning: [
                        PartOdDayColor(color: .green, percentage: 80)
                    ],
                    day: [
                        PartOdDayColor(color: .yellow, percentage: 30)
                    ],
                    evening: [
                        PartOdDayColor(color: .red, percentage: 50)
                    ],
                    lateEvening: [
                        PartOdDayColor(color: .blue, percentage: 10)
                    ]
                )
            )
        ),
        StatWeek(
            week: "10-16 фев",
            data: WeekStatistic(
                redPercent: 50,
                bluePercent: 30,
                greenPercent: 20,
                orangePercent: 0,
                amountOfNotes: 8,

                dayData: [],

                frequencyData: [],
                partsOfDayStatistic: PartsOfDayStatistic(
                    earlyMorning: [
                        PartOdDayColor(color: .red, percentage: 60),
                        PartOdDayColor(color: .blue, percentage: 40)
                    ],
                    morning: [
                        PartOdDayColor(color: .green, percentage: 80)
                    ],
                    day: [
                        PartOdDayColor(color: .yellow, percentage: 30)
                    ],
                    evening: [
                        PartOdDayColor(color: .red, percentage: 50)
                    ],
                    lateEvening: [
                        PartOdDayColor(color: .blue, percentage: 10)
                    ]
                )
            )
        ),
        StatWeek(
            week: "3-9 фев",
            data: WeekStatistic(
                redPercent: 10,
                bluePercent: 10,
                greenPercent: 60,
                orangePercent: 20,
                amountOfNotes: 12,

                dayData: [],

                frequencyData: [],
                partsOfDayStatistic: PartsOfDayStatistic(
                    earlyMorning: [
                        PartOdDayColor(color: .red, percentage: 60),
                        PartOdDayColor(color: .blue, percentage: 40)
                    ],
                    morning: [
                        PartOdDayColor(color: .green, percentage: 80)
                    ],
                    day: [
                        PartOdDayColor(color: .yellow, percentage: 30)
                    ],
                    evening: [
                        PartOdDayColor(color: .red, percentage: 50)
                    ],
                    lateEvening: [
                        PartOdDayColor(color: .blue, percentage: 10)
                    ]
                )
            )
        ),
        StatWeek(
            week: "27 янв - 2 фев",
            data: WeekStatistic(
                redPercent: 25,
                bluePercent: 25,
                greenPercent: 25,
                orangePercent: 25,
                amountOfNotes: 16,

                dayData: [],

                frequencyData: [],
                partsOfDayStatistic: PartsOfDayStatistic(
                    earlyMorning: [
                        PartOdDayColor(color: .red, percentage: 60),
                        PartOdDayColor(color: .blue, percentage: 40)
                    ],
                    morning: [
                        PartOdDayColor(color: .green, percentage: 80)
                    ],
                    day: [
                        PartOdDayColor(color: .yellow, percentage: 30)
                    ],
                    evening: [
                        PartOdDayColor(color: .red, percentage: 50)
                    ],
                    lateEvening: [
                        PartOdDayColor(color: .blue, percentage: 10)
                    ]
                )
            )
        )
    ]
}
