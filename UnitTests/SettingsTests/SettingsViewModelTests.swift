//
//  SettingsViewModelTests.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 24.05.2025.
//

import XCTest
@testable import MyEmotions

final class SettingsViewModelTests: XCTestCase {

    var repository: MockSettingsRepository!
    var delegate: MockSettingsDelegate!
    var viewModel: SettingsViewModel!

    override func setUp() {
        super.setUp()
        repository = MockSettingsRepository()
        delegate = MockSettingsDelegate()
        viewModel = SettingsViewModel(delegate: delegate, repository: repository)
    }
    override func tearDown() {
        repository = nil
        delegate = nil
        viewModel = nil
        super.tearDown()
    }

    /// добавление напоминания должно вызывать репозиторий и обновлять published
    func testAddReminderTime_updatesRepositoryAndPublished() {
        viewModel.addReminderTime("08:30")
        XCTAssertEqual(repository.addReminderCalledWith, "08:30")
        XCTAssertEqual(viewModel.reminderTimes, ["08:30"])
    }

    /// переключение напоминаний должно сохраняться
    func testSetRemindersEnabled_savesToRepoAndPublishes() {
        viewModel.setRemindersEnabled(true)
        XCTAssertEqual(repository.updateRemindersEnabledCalledWith, true)
        XCTAssertTrue(viewModel.isRemindersEnabled)
    }

    /// переключение Face ID должно сохраняться
    func testSetFaceIDEnabled_savesToRepoAndPublishes() {
        viewModel.setFaceIDEnabled(true)
        XCTAssertEqual(repository.updateFaceIdCalledWith, true)
        XCTAssertTrue(viewModel.isFaceIDEnabled)
    }

    /// logoutTapped должен вызвать делегат
    func testLogoutTapped_callsDelegate() {
        viewModel.logoutTapped()
        XCTAssertTrue(delegate.didRequestLogoutCalled)
    }

    /// updateAvatar должен сохранить изображение в репозиторий
    func testUpdateAvatar_savesToRepository() {
        let image = UIImage()
        viewModel.updateAvatar(image)
        XCTAssertTrue(repository.saveAvatarCalledWith === image)
    }

    /// didTapGalleryOption должен вызвать делегат presentPhotoPicker
    func testDidTapGalleryOption_callsDelegate() {
        viewModel.didTapGalleryOption()
        XCTAssertTrue(delegate.presentPhotoPickerCalled)
    }
}
