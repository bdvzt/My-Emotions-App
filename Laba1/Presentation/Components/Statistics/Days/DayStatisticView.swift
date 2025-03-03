//
//  DayStatisticView.swift
//  LAB1
//
//  Created by Zayata Budaeva on 28.02.2025.
//

import UIKit
import SnapKit

final class DayStatisticView: UIView {

    // MARK: - Private properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Эмоции \nпо дням недели"
        label.font = UIFont(name: "Gwen-Trial-Regular", size: 36)
        label.textColor = .white
        return label
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        return view
    }()

    private var cards: [DayStaticsticCard] = []

    // MARK: - Inits

    init(dayData: [DayData]) {
        super.init(frame: .zero)
        setup(dayData: dayData)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(dayData: [DayData]) {
        backgroundColor = .black
        setupTitleLabel()
        setupScrollView(dayData: dayData)
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }

    private func setupScrollView(dayData: [DayData]) {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        var previousCard: UIView? = nil
        for data in dayData {
            let card = DayStaticsticCard(day: data.day, date: data.date, moodsTitles: data.moodsTitles, moodsImages: data.moodsImages)
            cards.append(card)
            contentView.addSubview(card)

            card.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                if let previous = previousCard {
                    make.top.equalTo(previous.snp.bottom)
                } else {
                    make.top.equalToSuperview()
                }
            }

            previousCard = card
        }
    }
}

