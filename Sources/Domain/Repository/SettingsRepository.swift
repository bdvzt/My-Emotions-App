//
//  SettingsRepository.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 13.05.2025.
//

import UIKit

protocol SettingsRepository {
    var firstName: String { get }
    var lastName: String { get }
    var avatar: UIImage { get }

    var isRemindersEnabled: Bool { get set }
    var isFaceIDEnabled: Bool { get set }

    var reminderTimes: [String] { get }
    func addReminderTime(_ time: String)
    func deleteReminderTime(_ time: String)
}
