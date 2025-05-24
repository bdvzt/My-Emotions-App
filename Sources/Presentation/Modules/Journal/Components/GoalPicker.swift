//
//  GoalPicker.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 20.05.2025.
//

import UIKit
import SnapKit

final class GoalPicker: UIViewController {
    
    // MARK: - Properties
    private let picker = UIPickerView()
    private let alertView = UIView()
    private let titleLabel = UILabel()
    private let cancelButton = UIButton(type: .system)
    private let confirmButton = UIButton(type: .system)
    private let buttonStack = UIStackView()
    
    private let onValueSelected: (Int) -> Void
    private var selectedValue: Int
    
    // MARK: - Init
    init(initialValue: Int, onValueSelected: @escaping (Int) -> Void) {
        self.onValueSelected = onValueSelected
        self.selectedValue = initialValue
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup
    private func setupUI() {
        setupAlertView()
        setupTitleLabel()
        setupPicker()
        setupButtons()
        setupButtonStack()
    }
    
    private func setupAlertView() {
        alertView.backgroundColor = .systemBackground
        alertView.layer.cornerRadius = 16
        view.addSubview(alertView)
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Выберите цель на день"
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textAlignment = .center
        alertView.addSubview(titleLabel)
    }
    
    private func setupPicker() {
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(selectedValue - 1, inComponent: 0, animated: false)
        alertView.addSubview(picker)
    }
    
    private func setupButtons() {
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelSelection), for: .touchUpInside)
        
        confirmButton.setTitle("Готово", for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmSelection), for: .touchUpInside)
    }
    
    private func setupButtonStack() {
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(confirmButton)
        alertView.addSubview(buttonStack)
    }
    
    private func setupConstraints() {
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(alertView.snp.top).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        picker.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(picker.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    // MARK: - Actions
    @objc private func confirmSelection() {
        dismiss(animated: true) {
            self.onValueSelected(self.selectedValue)
        }
    }
    
    @objc private func cancelSelection() {
        dismiss(animated: true, completion: nil)
    }
}

extension GoalPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = row + 1
    }
}
