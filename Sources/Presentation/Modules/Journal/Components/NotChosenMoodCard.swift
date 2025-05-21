//
//  NotChosenMoodCard.swift
//  LAB1
//
//  Created by Zayata Budaeva on 26.02.2025.
//

import UIKit
import SnapKit

final class NotChosenMoodCard: UIView {
    // MARK: - Subviews
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 12)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Выберите эмоцию, лучше всего описывающую, что вы сейчас чувствуете"
        return label
    }()

    lazy var arrowView: RightArrow = {
        RightArrow(chosen: false)
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [messageLabel, arrowView])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Setup
    private func commonInit() {
        setupAppearance()
        setupLayout()
    }

    private func setupAppearance() {
        backgroundColor = .tabBar
        layer.cornerRadius = 40
        clipsToBounds = true
    }

    private func setupLayout() {
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(8)
        }

        arrowView.snp.makeConstraints { make in
            make.width.height.equalTo(64)
        }
    }
}
