//
//  ChosenMoodCard.swift
//  LAB1
//
//  Created by Zayata Budaeva on 26.02.2025.
//

import UIKit
import SnapKit

final class ChosenMoodCard: UIView {
    // MARK: - Properties
    private let mood: Mood

    // MARK: - Subviews
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 12)
        label.textColor = mood.uiColor
        label.text = mood.title
        label.textAlignment = .left
        return label
    }()

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 12)
        label.textColor = .white
        label.text = mood.moodInfo
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()

    private lazy var labelsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, infoLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()

    lazy var arrowView: RightArrow = {
        let view = RightArrow(chosen: true)
        return view
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [labelsStack, arrowView])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()

    // MARK: - Init
    init(mood: Mood) {
        self.mood = mood
        super.init(frame: .zero)
        setupAppearance()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
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
