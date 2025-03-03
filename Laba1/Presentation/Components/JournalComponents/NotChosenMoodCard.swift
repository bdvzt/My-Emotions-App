//
//  NotChosenMoodCard.swift
//  LAB1
//
//  Created by Zayata Budaeva on 26.02.2025.
//

import UIKit
import SnapKit

final class NotChosenMoodCard: UIView {

    // MARK: - Private properties

    let chooseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 12)
        label.textColor = .white
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "Выберите эмоцию, лучше всего описывающую, что вы сейчас чувствуете"
        return label
    }()

    let arrowView: RightArrow = {
        let view = RightArrow(chosen: false)
        return view
    }()

    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()

    // MARK: - Inits

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        setupBackground()
        setupStackView()
    }

    private func setupBackground() {
        backgroundColor = .tabBar
        layer.cornerRadius = 40
    }

    private func setupStackView() {
        addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(chooseLabel)
        horizontalStackView.addArrangedSubview(arrowView)

        horizontalStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-10)
            make.top.bottom.equalToSuperview().inset(10)
        }

        chooseLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }

        arrowView.snp.makeConstraints { make in
            make.width.height.equalTo(64)
        }
    }
}
