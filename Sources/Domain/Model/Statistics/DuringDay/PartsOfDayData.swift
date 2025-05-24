//
//  PartsOfDayData.swift
//  LAB1
//
//  Created by Zayata Budaeva on 02.03.2025.
//

import UIKit

struct PartOfDayStat {
    let colors: [PartOdDayColor]
    let amount: Int
}

struct PartsOfDayData {
    let earlyMorning: PartOfDayStat
    let morning: PartOfDayStat
    let day: PartOfDayStat
    let evening: PartOfDayStat
    let lateEvening: PartOfDayStat
}
