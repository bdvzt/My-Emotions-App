//
//  MostFrequentlyView.swift
//  LAB1
//
//  Created by Zayata Budaeva on 02.03.2025.
//

import UIKit
import SnapKit

final class MostFrequentlyView: UIView {

    // MARK: - Private properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Самые частые \nэмоции"
        label.font = UIFont(name: "Gwen-Trial-Regular", size: 36)
        label.textColor = .white
        return label
    }()

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    // MARK: - Init

    init(data: [FrequencyData]) {
        super.init(frame: .zero)

        let maxAmount = data.map { $0.amount }.max() ?? 1

        let cards = data.map { FrequencyCard(data: $0, maxAmount: maxAmount) }
        setupView(cards: cards)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView(cards: [FrequencyCard]) {
        addSubview(titleLabel)
        addSubview(scrollView)
        scrollView.addSubview(stackView)

        stackView.axis = .vertical
        stackView.spacing = 8

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        cards.forEach { card in
            stackView.addArrangedSubview(card)

            card.snp.makeConstraints { make in
                make.height.equalTo(32)
            }
        }
    }
}
