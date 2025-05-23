//
//  SettingsViewController.swift
//  LAB1
//
//  Created by Zayata Budaeva on 20.02.2025.
//

import UIKit
import SnapKit
import Combine
import PhotosUI

final class SettingsViewController: UIViewController {

    // MARK: - Dependencies
    private let settingsViewModel: SettingsViewModel

    // MARK: - Private properties
    private var cancellables = Set<AnyCancellable>()

    private let settingsScrollView = UIScrollView()
    private let settingsContentView = UIView()

    private let settingsLabel = UILabel()
    private let sendAlert = SendAlertComponent()
    private let addReminderButton = WhiteButton(title: "Добавить напоминание")
    private let touchIdSwitchBar = TouchIdSwitchBar()

    private let timeStackView = UIStackView()
    private let pickerContainerView = UIView()
    private let timePicker = UIDatePicker()
    private let saveButton = WhiteButton(title: "Сохранить")

    private lazy var avatarView = AvatarWithName(
        avatarImage: settingsViewModel.avatar,
        name: "\(settingsViewModel.firstName) \(settingsViewModel.lastName)"
    )

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

    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.right.circle"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Inits

    init(settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Setup

    private func setup() {
        view.backgroundColor = .black
        view.addSubview(settingsScrollView)
        settingsScrollView.addSubview(settingsContentView)

        settingsScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        settingsContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        settingsScrollView.contentInsetAdjustmentBehavior = .never

        setupSettingsLabel()
        setupAvatarView()
        setupSendAlert()
        setupTimeStackView()
        setupAddReminderButton()
        setupTouchIdSwitchBar()
        setupPicker()
        setupActions()
        updateEmptyState()
    }

    private func setupSettingsLabel() {
        let headerStack = UIStackView(arrangedSubviews: [settingsLabel, logoutButton])
        headerStack.axis = .horizontal
        headerStack.spacing = 8
        headerStack.alignment = .center
        headerStack.distribution = .equalSpacing

        settingsLabel.text = "Настройки"
        settingsLabel.font = UIFont(name: "Gwen-Trial-Regular", size: 36)
        settingsLabel.textColor = .white
        settingsLabel.textAlignment = .left

        settingsContentView.addSubview(headerStack)
        headerStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
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

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarView.isUserInteractionEnabled = true
        avatarView.addGestureRecognizer(tapGesture)
    }

    private func setupSendAlert() {
        settingsContentView.addSubview(sendAlert)
        sendAlert.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        sendAlert.setOnToggle = { [weak self] isOn in
            self?.settingsViewModel.setRemindersEnabled(isOn)
        }
    }

    private func setupTimeStackView() {
        settingsContentView.addSubview(timeStackView)
        timeStackView.axis = .vertical
        timeStackView.spacing = 12
        timeStackView.alignment = .fill
        timeStackView.distribution = .equalSpacing

        timeStackView.snp.makeConstraints { make in
            make.top.equalTo(sendAlert.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
    }

    private func setupAddReminderButton() {
        settingsContentView.addSubview(addReminderButton)
        addReminderButton.snp.makeConstraints { make in
            make.top.equalTo(timeStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
    }

    private func setupTouchIdSwitchBar() {
        settingsContentView.addSubview(touchIdSwitchBar)
        touchIdSwitchBar.snp.makeConstraints { make in
            make.top.equalTo(addReminderButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }

        touchIdSwitchBar.setOnToggle = { [weak self] isOn in
            self?.settingsViewModel.toggleFaceID(to: isOn)
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

        settingsViewModel.addReminderTime(timeString)
        pickerContainerView.isHidden = true
    }

    @objc private func logoutButtonTapped() {
        settingsViewModel.logoutTapped()
    }

    @objc private func avatarTapped() {
        let alert = UIAlertController(title: "Выбери источник для выбора аватарки", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Камера", style: .default) { [weak self] _ in
            self?.settingsViewModel.didTapCameraOption()
        })

        alert.addAction(UIAlertAction(title: "Галерея", style: .default) { [weak self] _ in
            self?.settingsViewModel.didTapGalleryOption()
        })

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))

        present(alert, animated: true)
    }

    private func removeReminderTime(_ time: String) {
        settingsViewModel.deleteReminderTime(time)
    }

    private func updateReminders(_ times: [String]) {
        timeStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        for time in times {
            let reminder = ReminderTime(time: time)
            reminder.onDelete = { [weak self] in
                self?.removeReminderTime(time)
            }
            timeStackView.addArrangedSubview(reminder)
        }

        emptyStateLabel.isHidden = !times.isEmpty
    }

    private func handleErrorState() {
        emptyStateLabel.isHidden = true
        errorLabel.isHidden = false

        settingsLabel.isHidden = true
        avatarView.isHidden = true
        sendAlert.isHidden = true
        addReminderButton.isHidden = true
        touchIdSwitchBar.isHidden = true
        pickerContainerView.isHidden = true
        saveButton.isHidden = true
    }

    private func updateReminderToggle(_ isOn: Bool) {
        sendAlert.setSwitchState(isOn)
    }

    @objc private func faceIDSwitchChanged(_ sender: UISwitch) {
        settingsViewModel.toggleFaceID(to: sender.isOn)
    }

    func setFaceIDSwitchState(_ isOn: Bool) {
        touchIdSwitchBar.setSwitchState(isOn)
    }

    // MARK: - Binding
    private func bindViewModel() {
        settingsViewModel.$reminderTimes
            .receive(on: RunLoop.main)
            .sink { [weak self] times in
                self?.updateReminders(times)
            }
            .store(in: &cancellables)

        settingsViewModel.$isRemindersEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isOn in
                self?.updateReminderToggle(isOn)
            }
            .store(in: &cancellables)

        settingsViewModel.$isFaceIDEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isOn in
                self?.setFaceIDSwitchState(isOn)
            }
            .store(in: &cancellables)
    }
}

extension SettingsViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else { return }

        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let image = image as? UIImage else { return }
            DispatchQueue.main.async {
                self?.avatarView.setImage(image)
                self?.settingsViewModel.updateAvatar(image)
            }
        }
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            avatarView.setImage(image)
            settingsViewModel.updateAvatar(image)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
