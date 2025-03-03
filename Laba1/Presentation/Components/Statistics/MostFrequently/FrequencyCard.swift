//
//  FrequencyCard.swift
//  LAB1
//
//  Created by Zayata Budaeva on 02.03.2025.
//

import UIKit
import SnapKit

final class FrequencyCard: UIView {

    // MARK: - Private properties

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private let emotionIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let frequencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "VelaSans-Regular", size: 16)
        label.textAlignment = .left
        return label
    }()

    private let statisticsContainerView = UIView()
    private let frequencyStatistics: FrequencyStatistics
    private let maxAmount: Int
    private let currentAmount: Int

    // MARK: - Inits

    init(data: FrequencyData, maxAmount: Int) {
        self.maxAmount = maxAmount
        self.currentAmount = data.amount
        self.frequencyStatistics = FrequencyStatistics(
            firstColor: data.firstColor,
            secondColor: data.secondColor,
            amount: data.amount
        )
        super.init(frame: .zero)

        emotionIcon.image = data.image
        frequencyLabel.text = data.emotion

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        addSubview(stackView)
        stackView.addArrangedSubview(emotionIcon)
        stackView.addArrangedSubview(frequencyLabel)
        stackView.addArrangedSubview(statisticsContainerView)

        statisticsContainerView.addSubview(frequencyStatistics)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        emotionIcon.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.1)
        }

        frequencyLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        statisticsContainerView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.40)
            make.height.equalTo(32)
        }

        let widthMultiplier = CGFloat(currentAmount) / CGFloat(maxAmount)

        frequencyStatistics.snp.makeConstraints { make in
            make.width.equalTo(statisticsContainerView.snp.width).multipliedBy(widthMultiplier)
            make.height.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
}
