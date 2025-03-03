//
//  StatisticsForAWeek.swift
//  LAB1
//
//  Created by Zayata Budaeva on 28.02.2025.
//

import UIKit
import SnapKit

final class StatisticsForAWeek: UIView {

    // MARK: - Private properties

    private let categoryView: CategoryView
    private let dayStatisticView: DayStatisticView
    private let mostFrequentlyView: MostFrequentlyView
    private let duringDayView: DuringDayView

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // MARK: - Inits

    init(data: WeekStatistic) {
        self.categoryView = CategoryView(
            amountOfNotes: data.amountOfNotes,
            redPercent: data.redPercent,
            bluePercent: data.bluePercent,
            greenPercent: data.greenPercent,
            orangePercent: data.orangePercent
        )

        self.dayStatisticView = DayStatisticView(dayData: data.dayData)
        self.mostFrequentlyView = MostFrequentlyView(data: data.frequencyData)
        self.duringDayView = DuringDayView(data: data.partsOfDayStatistic)

        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        contentView.addSubview(categoryView)
        categoryView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(600)
        }

        contentView.addSubview(dayStatisticView)
        dayStatisticView.snp.makeConstraints { make in
            make.top.equalTo(categoryView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(600)
        }

        contentView.addSubview(mostFrequentlyView)
        mostFrequentlyView.snp.makeConstraints { make in
            make.top.equalTo(dayStatisticView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(600)
        }

        contentView.addSubview(duringDayView)
        duringDayView.snp.makeConstraints { make in
            make.top.equalTo(mostFrequentlyView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(600)
        }
    }
}
