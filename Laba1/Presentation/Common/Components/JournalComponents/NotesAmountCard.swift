//
//  NotesAmountCard.swift
//  LAB1
//
//  Created by Zayata Budaeva on 20.02.2025.
//

import UIKit
import SnapKit

final class NotesAmountCard: UIView
{
    // MARK: - UI Elements

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 12)
        label.textColor = .white
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Bold", size: 12)
        label.textColor = .white
        return label
    }()

    private let labelStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.alignment = .center
        return stack
    }()

    // MARK: - Inits

    init(description: String, amount: String) {
        super.init(frame: .zero)
        setup(description: description, amount: amount)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(description: String, amount: String) {
        setupView()
        setupLabels(description: description, amount: amount)
        setupConstraints()
    }

    private func setupView() {
        backgroundColor = .amountGray
        layer.cornerRadius = 20
        addSubview(labelStackView)
    }

    private func setupLabels(description: String, amount: String) {
        descriptionLabel.text = description
        amountLabel.text = amount

        labelStackView.addArrangedSubview(descriptionLabel)
        labelStackView.addArrangedSubview(amountLabel)
    }

    private func setupConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        self.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(40)
        }
    }
}
