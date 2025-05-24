//
//  MockSettingsRepository.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 24.05.2025.
//

import XCTest
@testable import MyEmotions

final class MockSettingsRepository: SettingsRepository {
    var firstName = "Степан"
    var lastName = "Потапов"
    var avatar = UIImage()

    private(set) var storedReminderTimes: [String] = []

    var remindersEnabled = false
    var faceIdEnabled = false

    var saveAvatarCalledWith: UIImage?
    func saveAvatar(_ image: UIImage) {
        saveAvatarCalledWith = image
    }

    var addReminderCalledWith: String?
    func addReminderTime(_ time: String) {
        storedReminderTimes.append(time)
        addReminderCalledWith = time
    }

    var deleteReminderCalledWith: String?
    func deleteReminderTime(_ time: String) {
        storedReminderTimes.removeAll { $0 == time }
        deleteReminderCalledWith = time
    }

    var updateFaceIdCalledWith: Bool?
    var updateRemindersEnabledCalledWith: Bool?
    func saveUserNameIfNeeded(givenName: String, familyName: String) { }

    var isRemindersEnabled: Bool {
        get { remindersEnabled }
        set { updateRemindersEnabledCalledWith = newValue; remindersEnabled = newValue }
    }

    var isFaceIDEnabled: Bool {
        get { faceIdEnabled }
        set { updateFaceIdCalledWith = newValue; faceIdEnabled = newValue }
    }

    var reminderTimes: [String] {
        return storedReminderTimes.sorted()
    }
}
