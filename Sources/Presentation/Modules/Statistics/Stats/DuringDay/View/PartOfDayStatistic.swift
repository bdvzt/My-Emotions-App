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
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        mainStack.spacing = 8

        addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let screenHeight = UIScreen.main.bounds.height
        let columnsStackViewHeight = screenHeight * 0.5

        mainStack.addArrangedSubview(columnStackView)
        columnStackView.snp.makeConstraints { make in
            make.height.equalTo(columnsStackViewHeight)
            make.width.equalToSuperview()
        }

        for part in data {
            let column = ColorColumn(moodCase: part.color, percentage: CGFloat(part.percentage))
            columnStackView.addArrangedSubview(column)

            column.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(columnsStackViewHeight * CGFloat(part.percentage) / 100.0)
            }
        }

        titleLabel.text = title
        amountLabel.text = "\(amount)"

        let labelStackContainer = UIView()
        labelStackContainer.addSubview(titleLabel)
        labelStackContainer.addSubview(amountLabel)

        mainStack.addArrangedSubview(labelStackContainer)
        labelStackContainer.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview()
        }
    }
}
