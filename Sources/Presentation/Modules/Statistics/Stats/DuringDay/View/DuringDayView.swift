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

        for (colors, title) in viewModel.partsOfDay {
            let columnView = makeColumn(from: colors, title: title)
            columnsStackView.addArrangedSubview(columnView)
        }
    }

    private func makeColumn(from data: [PartOdDayColor], title: String) -> UIView {
        guard !data.isEmpty else {
            return UIView()
        }
        let totalAmount = data.reduce(0) { $0 + $1.percentage }
        let statisticView = PartOfDayStatistic(data: data, title: title, amount: totalAmount)

        let containerView = UIView()
        containerView.addSubview(statisticView)

        containerView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(100) 
        }

        statisticView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }

        return containerView
    }
}
