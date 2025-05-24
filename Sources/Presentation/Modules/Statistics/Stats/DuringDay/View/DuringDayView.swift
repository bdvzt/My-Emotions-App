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
        stackView.distribution = .fillEqually
        return stackView
    }()

    // MARK: - Init

    init(viewModel: PartOfDayStatisticsViewModel) {
        super.init(frame: .zero)
        setup(with: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setup(with viewModel: PartOfDayStatisticsViewModel) {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        addSubview(columnsStackView)
        let screenHeight = UIScreen.main.bounds.height
        let columnsStackViewHeight = screenHeight * 0.5

        columnsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(columnsStackViewHeight)
        }

        for (colors, title, amount) in viewModel.partsOfDay {
            let columnView = makeColumn(from: colors, title: title, amount: amount)
            columnsStackView.addArrangedSubview(columnView)
        }
    }

    private func makeColumn(from data: [PartOdDayColor], title: String, amount: Int) -> UIView {
        let actualData: [PartOdDayColor]
        if data.isEmpty {
            actualData = [PartOdDayColor(color: .none, percentage: 100)]
        } else {
            actualData = data
        }

        let statisticView = PartOfDayStatistic(data: actualData, title: title, amount: amount)
        let containerView = UIView()
        containerView.addSubview(statisticView)

        statisticView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        return containerView
    }
}
