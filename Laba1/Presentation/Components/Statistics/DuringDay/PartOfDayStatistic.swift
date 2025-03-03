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

    private let columnStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        return stack
    }()

    private let labelStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 2
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 12)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 12)
        label.textColor = .tabBarUnselected
        label.textAlignment = .center
        return label
    }()

    // MARK: - Inits

    init(data: [PartOdDayColor], title: String, amount: Int) {
        super.init(frame: .zero)
        setup(data: data, title: title, amount: amount)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(data: [PartOdDayColor], title: String, amount: Int) {
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.spacing = 8

        addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        mainStack.addArrangedSubview(columnStackView)
        columnStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }

        let totalPercentage = data.reduce(0) { $0 + $1.percentage }

        for part in data {
            let column = ColorColumn(moodCase: part.color, percentage: CGFloat(part.percentage))
            columnStackView.addArrangedSubview(column)

            column.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(CGFloat(part.percentage) / CGFloat(totalPercentage))
            }
        }

        titleLabel.text = title
        amountLabel.text = "\(amount)"

        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(amountLabel)

        mainStack.addArrangedSubview(labelStackView)
        labelStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
}
