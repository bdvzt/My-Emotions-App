//
//  SettingsViewModel.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 13.05.2025.
//

import Combine
import UIKit

protocol SettingsViewModelDelegate: AnyObject {

}

final class SettingsViewModel {

    // MARK: - Properties
    weak var delegate: SettingsViewModelDelegate?
    private var repository: SettingsRepository

    // MARK: - Published
    @Published var reminderTimes: [String]
    @Published var isRemindersEnabled: Bool
    @Published var isFaceIDEnabled: Bool

    // MARK: - Init
    init(delegate: SettingsViewModelDelegate? = nil, repository: SettingsRepository) {
        self.delegate = delegate
        self.repository = repository

        self.reminderTimes = repository.reminderTimes
        self.isRemindersEnabled = repository.isRemindersEnabled
        self.isFaceIDEnabled = repository.isFaceIDEnabled
    }

    // MARK: - User information
    var firstName: String { repository.firstName }
    var lastName: String { repository.lastName }
    var avatar: UIImage { repository.avatar }

    // MARK: - Actions
    func addReminderTime(_ time: String) {
        repository.addReminderTime(time)
        reminderTimes = repository.reminderTimes
    }

    func deleteReminderTime(_ time: String) {
        repository.deleteReminderTime(time)
        reminderTimes = repository.reminderTimes
    }

    func setFaceIDEnabled(_ isOn: Bool) {
        repository.isFaceIDEnabled = isOn
        isFaceIDEnabled = isOn
    }

    func setRemindersEnabled(_ isOn: Bool) {
        repository.isRemindersEnabled = isOn
        isRemindersEnabled = isOn
    }
}
