//
//  ChosenMoodCard.swift
//  LAB1
//
//  Created by Zayata Budaeva on 26.02.2025.
//

import UIKit
import SnapKit

final class ChosenMoodCard: UIView {

    let moodColor: UIColor
    let moodName: String
    let arrowView: RightArrow = {
        let view = RightArrow(chosen: true)
        return view
    }()

    // MARK: - Private properties

    private let chosenMoodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 12)
        label.textAlignment = .left
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 12)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    private let moodStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()

    // MARK: - Init

    init(color: UIColor, mood: String, description: String) {
        self.moodColor = color
        self.moodName = mood
        super.init(frame: .zero)
        setup(color: color, mood: mood, description: description)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(color: UIColor, mood: String, description: String) {
        setupBackground()
        setupLabels(color: color, mood: mood, description: description)
        setupStackView()
    }

    private func setupBackground() {
        backgroundColor = .tabBar
        layer.cornerRadius = 40
    }

    private func setupLabels(color: UIColor, mood: String, description: String) {
        chosenMoodLabel.text = mood
        chosenMoodLabel.textColor = color

        descriptionLabel.text = description

        moodStackView.addArrangedSubview(chosenMoodLabel)
        moodStackView.addArrangedSubview(descriptionLabel)
    }

    private func setupStackView() {
        addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(moodStackView)
        horizontalStackView.addArrangedSubview(arrowView)

        horizontalStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-10)
            make.top.bottom.equalToSuperview().inset(10)
        }

        arrowView.snp.makeConstraints { make in
            make.width.height.equalTo(64)
        }
    }
}
