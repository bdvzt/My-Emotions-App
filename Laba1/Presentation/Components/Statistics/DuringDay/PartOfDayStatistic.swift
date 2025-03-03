//
//  PartOfDayStatistic.swift
//  LAB1
//
//  Created by Zayata Budaeva on 02.03.2025.
//

import UIKit
import SnapKit

final class PartOfDayStatistic: UIView {

    // MARK: - Private properties

    private let stackView = UIStackView()

    // MARK: - Inits

    init(colors: [PartOdDayColor]) {
        super.init(frame: .zero)
        setup(colors)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(_ data: [PartOdDayColor]) {
        stackView.axis = .vertical
        stackView.spacing = 8
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        data.forEach { emotion in
            let column = ColorColumn()
            column.moodCase = emotion.color
            column.percentage = CGFloat(emotion.percentage)
            stackView.addArrangedSubview(column)
        }
    }
}
