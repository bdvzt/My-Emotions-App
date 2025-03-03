//
//  StatisticsViewController.swift
//  LAB1
//
//  Created by Zayata Budaeva on 20.02.2025.
//

import UIKit
import SnapKit

class StatisticsViewController: UIViewController {

    // MARK: - Private properties

    private var weeks: [StatWeek] = []
    private var currentIndex: Int = 0

    private let chooseWeekScrollView = UIScrollView()
    private let chooseWeekButtons = UIStackView()
    private let indicatorLine = UIView()
    private let weeksLine = UIView()

    private let mainContentView = UIView()
    private var statisticsForAWeekView: StatisticsForAWeek?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        setupWeeks()
        setupView()
        showStatistics(for: currentIndex)
    }

    private func setupWeeks() {
        weeks = createMockWeeksData()

        for index in 0..<weeks.count {
            let week = weeks[index]
            let button = setupWeekButton(for: week, index: index)
            chooseWeekButtons.addArrangedSubview(button)
        }
    }

    private func setupWeekButton(for week: StatWeek, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(week.week, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "VelaSans-Regular", size: 16)
        button.tag = index
        button.addTarget(self, action: #selector(weekButtonTapped(_:)), for: .touchUpInside)
        return button
    }

    private func setupView() {
        view.backgroundColor = .black
        setupScrollView()
        setupIndicatorLine()
        updateIndicatorLinePosition()
        setupWeeksLine()
        setupMainScrollView()
    }

    private func setupScrollView() {
        view.addSubview(chooseWeekScrollView)
        chooseWeekScrollView.addSubview(chooseWeekButtons)

        chooseWeekScrollView.showsHorizontalScrollIndicator = false
        chooseWeekScrollView.alwaysBounceHorizontal = true
        chooseWeekScrollView.bounces = true

        chooseWeekButtons.axis = .horizontal
        chooseWeekButtons.spacing = 16

        chooseWeekScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(50)
        }

        chooseWeekButtons.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.greaterThanOrEqualTo(chooseWeekScrollView.snp.width)
        }
    }

    private func setupIndicatorLine() {
        indicatorLine.backgroundColor = .white
        chooseWeekButtons.addSubview(indicatorLine)
        updateIndicatorLinePosition()
    }

    private func updateIndicatorLinePosition() {
        guard let button = chooseWeekButtons.arrangedSubviews[currentIndex] as? UIButton else {
            return
        }

        let buttonWidth = button.frame.width

        indicatorLine.snp.remakeConstraints { make in
            make.top.equalTo(button.snp.bottom)
            make.height.equalTo(3)
            make.width.equalTo(buttonWidth)
            make.leading.equalTo(button.snp.leading)
        }

        UIView.animate(withDuration: 0.3) {
            self.chooseWeekButtons.layoutIfNeeded()
        }
    }

    private func setupWeeksLine() {
        weeksLine.backgroundColor = .lightGray
        view.addSubview(weeksLine)
        weeksLine.snp.makeConstraints { make in
            make.top.equalTo(indicatorLine.snp.bottom)
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
    }

    private func setupMainScrollView() {
        view.addSubview(mainContentView)

        mainContentView.snp.makeConstraints { make in
            make.top.equalTo(chooseWeekScrollView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    @objc private func weekButtonTapped(_ sender: UIButton) {
        currentIndex = sender.tag
        showStatistics(for: currentIndex)
        updateIndicatorLinePosition()
    }

    private func showStatistics(for index: Int) {
        statisticsForAWeekView?.removeFromSuperview()

        guard index < weeks.count else { return }
        let weekData = weeks[index].data

        let statisticsView = StatisticsForAWeek(data: weekData)
        statisticsForAWeekView = statisticsView

        mainContentView.addSubview(statisticsView)
        statisticsView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.greaterThanOrEqualTo(1400)
        }
    }
}

#Preview {
    StatisticsViewController()
}

