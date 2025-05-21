//
//  GradientPair.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 21.05.2025.
//

import UIKit

struct GradientPair: Hashable {
    let start: UIColor
    let end: UIColor
}

let moodColorGradients: [UIColor: GradientPair] = [
    .moodRed: GradientPair(
        start: UIColor(named: "RedGradient") ?? .red,
        end: UIColor(named: "FeelingGradientRed") ?? .red
    ),
    .moodOrange: GradientPair(
        start: UIColor(named: "OrangeGradient") ?? .orange,
        end: UIColor(named: "FeelingGradientOrange") ?? .orange
    ),
    .moodGreen: GradientPair(
        start: UIColor(named: "GreenGradient") ?? .green,
        end: UIColor(named: "FeelingGradientGreen") ?? .green
    ),
    .moodBlue: GradientPair(
        start: UIColor(named: "BlueGradient") ?? .blue,
        end: UIColor(named: "FeelingGradientBlue") ?? .blue
    )
]

