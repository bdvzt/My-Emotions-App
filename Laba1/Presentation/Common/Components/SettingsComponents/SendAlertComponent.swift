//
//  SendAlertComponent.swift
//  LAB1
//
//  Created by Zayata Budaeva on 24.02.2025.
//

import UIKit
import SnapKit

final class SendAlertComponent: UIView
{
    // MARK: - Private properties
    var setOnToggle: ((Bool) -> Void)?

    private let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()

    private let alertImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .alert
        imageView.tintColor = .white
        return imageView
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Присылать напоминания"
        label.textColor = .white
        label.font = UIFont(name: "VelaSans-Regular", size: 16)
        label.textAlignment = .left
        return label
    }()

    private let switchBar: UISwitch = {
        let switchBar = UISwitch()
        switchBar.onTintColor = .systemGreen
        switchBar.backgroundColor = .white
        switchBar.layer.cornerRadius = 16
        switchBar.clipsToBounds = true
        switchBar.thumbTintColor = .circleProgressBarGray
        return switchBar
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        switchBar.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(horizontalStackView)

        horizontalStackView.addArrangedSubview(alertImage)
        horizontalStackView.addArrangedSubview(textLabel)
        horizontalStackView.addArrangedSubview(switchBar)

        setupConstraints()
    }

    private func setupConstraints() {
        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        alertImage.snp.makeConstraints { make in
            make.width.height.equalTo(23)
        }
    }

    func setSwitchState(_ isOn: Bool) {
        switchBar.setOn(isOn, animated: true)
        switchBar.thumbTintColor = isOn ? .white : .circleProgressBarGray
    }

    @objc private func switchValueChanged() {
        let isOn = switchBar.isOn
        switchBar.thumbTintColor = isOn ? .white : .circleProgressBarGray
        setOnToggle?(isOn)
    }
}
