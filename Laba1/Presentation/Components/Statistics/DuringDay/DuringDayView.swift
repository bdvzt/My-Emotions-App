//
//  DuringDayView.swift
//  LAB1
//
//  Created by Zayata Budaeva on 02.03.2025.
//

import UIKit
import SnapKit

final class DuringDayView: UIView {

    // MARK: - Private properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Ваше настроение \nв течение дня"
        label.font = UIFont(name: "Gwen-Trial-Regular", size: 36)
        label.textColor = .white
        return label
    }()

    private let columnsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .bottom
        return stackView
    }()

    // MARK: - Inits

    init(data: PartsOfDayStatistic) {
        super.init(frame: .zero)
        setup(with: data)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(with data: PartsOfDayStatistic) {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        addSubview(columnsStackView)
        columnsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        let earlyMorningColumn = makeColumn(from: data.earlyMorning, title: "Раннее утро")
        let morningColumn = makeColumn(from: data.morning, title: "Утро")
        let dayColumn = makeColumn(from: data.day, title: "День")
        let eveningColumn = makeColumn(from: data.evening, title: "Вечер")
        let lateEveningColumn = makeColumn(from: data.lateEvening, title: "Поздний вечер")

        columnsStackView.addArrangedSubview(earlyMorningColumn)
        columnsStackView.addArrangedSubview(morningColumn)
        columnsStackView.addArrangedSubview(dayColumn)
        columnsStackView.addArrangedSubview(eveningColumn)
        columnsStackView.addArrangedSubview(lateEveningColumn)
    }

    private func makeColumn(from data: [PartOdDayColor], title: String) -> ColorColumn {
        guard let first = data.first else {
            return ColorColumn(
                moodCase: .none,
                percentage: 0,
                title: title,
                amount: 0
            )
        }

        return ColorColumn(
            moodCase: first.color,
            percentage: CGFloat(first.percentage),
            title: title,
            amount: data.count
        )
    }
}
