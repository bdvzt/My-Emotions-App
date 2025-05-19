//
//  SettingsRepositoryImpl.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 13.05.2025.
//

import Foundation
import UIKit

final class SettingsRepositoryImpl: SettingsRepository {

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var firstName: String {
        userDefaults.string(forKey: Keys.firstName) ?? "Имя"
    }

    var lastName: String {
        userDefaults.string(forKey: Keys.lastName) ?? "Фамилия"
    }

    var avatar: UIImage {
        // TODO: настроить аватарку
        UIImage(resource: .avatar)
    }

    var isRemindersEnabled: Bool {
        get { userDefaults.bool(forKey: Keys.remindersEnabled) }
        set { userDefaults.set(newValue, forKey: Keys.remindersEnabled) }
    }

    var isFaceIDEnabled: Bool {
        get { userDefaults.bool(forKey: Keys.faceIdEnabled) }
        set { userDefaults.set(newValue, forKey: Keys.faceIdEnabled) }
    }

    var reminderTimes: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        return (userDefaults.stringArray(forKey: Keys.reminderTimes) ?? [])
            .sorted {
                guard
                    let date1 = formatter.date(from: $0),
                    let date2 = formatter.date(from: $1)
                else { return false }

                return date1 < date2
            }
    }

    func addReminderTime(_ time: String) {
        var times = reminderTimes
        times.append(time)
        userDefaults.set(times, forKey: Keys.reminderTimes)
    }

    func deleteReminderTime(_ time: String) {
        var times = reminderTimes
        if let index = times.firstIndex(of: time) {
            times.remove(at: index)
            userDefaults.set(times, forKey: Keys.reminderTimes)
        }
    }

    func saveUserNameIfNeeded(givenName: String, familyName: String) {
        userDefaults.set(givenName, forKey: Keys.firstName)
        userDefaults.set(familyName, forKey: Keys.lastName)
    }
}

private extension SettingsRepositoryImpl {
    enum Keys {
        static let firstName = "user_given_name"
        static let lastName = "user_family_name"
        static let avatarImage = "user_avatar_image"
        static let reminderTimes = "user_reminder_times"
        static let remindersEnabled = "user_reminders_enabled"
        static let faceIdEnabled = "user_face_id_enabled"
    }
}
