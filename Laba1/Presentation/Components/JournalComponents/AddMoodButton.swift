//
//  AddMoodButton.swift
//  LAB1
//
//  Created by Zayata Budaeva on 20.02.2025.
//

import UIKit
import SnapKit

final class AddMoodButton: UIControl {

    // MARK: - Private properties

    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 16)
        label.textColor = .white
        label.text = "Добавить запись"
        label.textAlignment = .center
        return label
    }()

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setImage(UIImage(resource: .plus), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 32
        button.clipsToBounds = true
        return button
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        setupStackView()
    }

    private func setupStackView() {
        stackView.addArrangedSubview(addButton)
        stackView.addArrangedSubview(label)

        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(64)
        }
        addButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        sendActions(for: .touchUpInside)
    }
}
