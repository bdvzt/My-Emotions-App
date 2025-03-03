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

    private let frequencyStatistics: FrequencyStatistics

    // MARK: - Init

    init(data: FrequencyData) {
        self.frequencyStatistics = FrequencyStatistics(firstColor: data.firstColor, secondColor: data.secondColor, perCent: data.percentage)
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
        stackView.addArrangedSubview(frequencyStatistics)

        stackView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
    }
}
