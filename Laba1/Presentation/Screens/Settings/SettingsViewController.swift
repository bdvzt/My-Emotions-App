//
//  SettingsViewController.swift
//  LAB1
//
//  Created by Zayata Budaeva on 20.02.2025.
//

import UIKit
import SnapKit

final class SettingsViewController: UIViewController {

    // MARK: - Private properties

    private let settingsScrollView = UIScrollView()
    private let settingsContentView = UIView()

    private let settingsLabel = UILabel()
    private let avatarView = AvatarWithName(avatarImage: .avatar, name: "Иван Иванов")
    private let sendAlert = SendAlertComponent()
    private let addReminderButton = WhiteButton(title: "Добавить напоминание")
    private let touchIdSwitchBar = TouchIdSwitchBar()

    private let timeScrollView = UIScrollView()
    private let timeContentView = UIView()
    private let timeStackView = UIStackView()
    private var timeScrollViewHeightConstraint: Constraint?
    private let pickerContainerView = UIView()
    private let timePicker = UIDatePicker()
    private let saveButton = WhiteButton(title: "Сохранить")

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет напоминаний"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "VelaSans-Regular", size: 18)
        label.isHidden = true
        return label
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Ошибка загрузки данных"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "VelaSans-Regular", size: 18)
        label.isHidden = true
        return label
    }()

    // MARK: - Inits

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        view.backgroundColor = .black

        view.addSubview(settingsScrollView)
        settingsScrollView.addSubview(settingsContentView)

        settingsScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        settingsContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        settingsScrollView.contentInsetAdjustmentBehavior = .never

        setupSettingsLabel()
        setupAvatarView()
        setupSendAlert()
        setupTimeScrollView()
        setupAddReminderButton()
        setupTouchIdSwitchBar()
        setupPicker()
        setupActions()
        updateEmptyState()
    }

    private func setupSettingsLabel() {
        settingsLabel.text = "Настройки"
        settingsLabel.font = UIFont(name: "Gwen-Trial-Regular", size: 36)
        settingsLabel.textColor = .white
        settingsLabel.textAlignment = .left

        settingsContentView.addSubview(settingsLabel)
        settingsLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            make.leading.equalToSuperview().inset(16)
        }
    }

    private func setupAvatarView() {
        settingsContentView.addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.top.equalTo(settingsLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(364)
            make.height.equalTo(136)
        }
    }

    private func setupSendAlert() {
        settingsContentView.addSubview(sendAlert)
        sendAlert.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(364)
            make.height.equalTo(50)
        }
    }

    private func setupTimeScrollView() {
        timeScrollView.showsVerticalScrollIndicator = false
        settingsContentView.addSubview(timeScrollView)
        timeScrollView.addSubview(timeContentView)
        timeContentView.addSubview(timeStackView)

        timeScrollView.snp.makeConstraints { make in
            make.top.equalTo(sendAlert.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            timeScrollViewHeightConstraint = make.height.equalTo(100).constraint
        }

        timeContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        timeStackView.axis = .vertical
        timeStackView.spacing = 12
        timeStackView.alignment = .fill

        timeStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.width.equalTo(364)
        }
    }

    private func setupAddReminderButton() {
        settingsContentView.addSubview(addReminderButton)
        addReminderButton.snp.makeConstraints { make in
            make.top.equalTo(timeScrollView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(364)
            make.height.equalTo(56)
        }
    }

    private func setupTouchIdSwitchBar() {
        settingsContentView.addSubview(touchIdSwitchBar)
        touchIdSwitchBar.snp.makeConstraints { make in
            make.top.equalTo(addReminderButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(364)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    private func setupPicker() {
        pickerContainerView.backgroundColor = .tabBar
        pickerContainerView.layer.cornerRadius = 16
        pickerContainerView.layer.masksToBounds = true
        pickerContainerView.isHidden = true

        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.setValue(UIColor.white, forKey: "textColor")

        view.addSubview(pickerContainerView)
        pickerContainerView.addSubview(timePicker)
        pickerContainerView.addSubview(saveButton)

        pickerContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(250)
        }

        timePicker.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(timePicker.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
            make.width.equalTo(200)
            make.height.equalTo(56)
        }
    }

    private func setupActions() {
        addReminderButton.addTarget(self, action: #selector(showTimePicker), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(addReminderTime), for: .touchUpInside)
    }

    private func updateTimeScrollViewHeight() {
        let newHeight = min(150, timeStackView.arrangedSubviews.count * 50)
        timeScrollViewHeightConstraint?.update(offset: newHeight)
    }

    private func updateEmptyState() {
        emptyStateLabel.isHidden = timeStackView.arrangedSubviews.isEmpty
    }

    // MARK: - Actions

    @objc private func showTimePicker() {
        pickerContainerView.isHidden = false
    }

    @objc private func addReminderTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: timePicker.date)

        let reminder = ReminderTime(time: timeString)
        reminder.onDelete = { self.removeReminderTime(reminder) }

        timeStackView.addArrangedSubview(reminder)
        updateTimeScrollViewHeight()
        pickerContainerView.isHidden = true
    }

    private func removeReminderTime(_ reminder: ReminderTime) {
        timeStackView.removeArrangedSubview(reminder)
        reminder.removeFromSuperview()
        updateTimeScrollViewHeight()
    }

    private func handleErrorState() {
        emptyStateLabel.isHidden = true
        errorLabel.isHidden = false

        settingsLabel.isHidden = true
        avatarView.isHidden = true
        sendAlert.isHidden = true
        timeScrollView.isHidden = true
        addReminderButton.isHidden = true
        touchIdSwitchBar.isHidden = true
        pickerContainerView.isHidden = true
        saveButton.isHidden = true
    }
}

#Preview {
    SettingsViewController()
}
