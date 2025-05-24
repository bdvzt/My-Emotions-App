//
//  Pluralization.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 20.05.2025.
//

import Foundation

enum Plural {
    static func form(_ number: Int, _ wordForms: (String, String, String)) -> String {
        let lastTwoDigits = number % 100
        let lastDigit = number % 10

        let correctForm: String

        if lastTwoDigits >= 11 && lastTwoDigits <= 14 {
            correctForm = wordForms.2
        } else {
            switch lastDigit {
            case 1:
                correctForm = wordForms.0
            case 2...4:
                correctForm = wordForms.1
            default:
                correctForm = wordForms.2
            }
        }

        return "\(number) \(correctForm)"
    }
}
