//
//  SettingsRepositoryTests.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 24.05.2025.
//

import XCTest
@testable import MyEmotions

final class SettingsRepositoryImplTests: XCTestCase {

    var defaults: UserDefaults!
    var repository: SettingsRepositoryImpl!

    override func setUp() {
        super.setUp()

        defaults = UserDefaults(suiteName: #file)
        defaults.removePersistentDomain(forName: #file)

        repository = SettingsRepositoryImpl(userDefaults: defaults)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: #file)

        repository = nil
        defaults = nil

        super.tearDown()
    }

    /// при наличии сохранённой картинки возвращает её
    func testLoadAvatar_returnsSavedImage() {
        let image = UIImage(systemName: "star")!
        repository.saveAvatar(image)

        let loaded = repository.avatar
        XCTAssertNotNil(loaded.pngData())
    }

    /// если в defaults нет картинки, то возвращается плейсхолдер
    func testLoadAvatar_whenNoData_returnsPlaceholder() {
        defaults.removeObject(forKey: "user_avatar_image")

        let loaded = repository.avatar
        XCTAssertNotNil(loaded)

        XCTAssertNotEqual(loaded.pngData(), Data())
    }

    /// firstName и lastName читаются из UserDefaults или дают Имя Фамилия
    func testFirstLastName_defaultsAndSave() {
        XCTAssertEqual(repository.firstName, "Имя")
        XCTAssertEqual(repository.lastName, "Фамилия")

        defaults.set("Степан", forKey: "user_given_name")
        defaults.set("Потапов", forKey: "user_family_name")

        XCTAssertEqual(repository.firstName, "Степан")
        XCTAssertEqual(repository.lastName, "Потапов")
    }

    /// напоминания сортируются, сохраняются, удаляются
    func testReminderTimes_addDeleteAndSorted() {
        defaults.set(["12:00","08:00"], forKey: "user_reminder_times")
        XCTAssertEqual(repository.reminderTimes, ["08:00","12:00"])

        repository.addReminderTime("09:00")
        XCTAssertEqual(defaults.stringArray(forKey: "user_reminder_times")!,
                       ["08:00","12:00","09:00"])
        XCTAssertEqual(repository.reminderTimes, ["08:00","09:00","12:00"])

        repository.deleteReminderTime("12:00")
        XCTAssertEqual(repository.reminderTimes, ["08:00","09:00"])
    }

    /// флаг напоминаний сохраняется
    func testRemindersEnabled_togglePersists() {
        XCTAssertFalse(repository.isRemindersEnabled)
        repository.isRemindersEnabled = true
        XCTAssertTrue(defaults.bool(forKey: "user_reminders_enabled"))
    }

    /// флаг Face ID сохраняется
    func testFaceIDEnabled_togglePersists() {
        XCTAssertFalse(repository.isFaceIDEnabled)
        repository.isFaceIDEnabled = true
        XCTAssertTrue(defaults.bool(forKey: "user_face_id_enabled"))
    }
}
