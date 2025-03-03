//
//  MoodGridView.swift
//  LAB1
//
//  Created by Zayata Budaeva on 26.02.2025.
//

import UIKit
import SnapKit

final class MoodGridView: UIView {

    // MARK: - Private properties

    private let redMoods = ["Ярость", "Напряжение", "Зависть", "Беспокойство"]
    private let orangeMoods = ["Возбуждение", "Восторг", "Уверенность", "Счастье"]
    private let blueMoods = ["Выгорание", "Усталость", "Депрессия", "Апатия"]
    private let greenMoods = ["Спокойствие", "Удовлетворенность", "Защищённость", "Благодарность"]

    var onMoodSelected: ((UIColor, String) -> Void)?

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupGrid()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupGrid() {
        let redStack = createMoodColorStack(moods: redMoods, color: .loginRed)
        let orangeStack = createMoodColorStack(moods: orangeMoods, color: .loginOrange)
        let blueStack = createMoodColorStack(moods: blueMoods, color: .loginBlue)
        let greenStack = createMoodColorStack(moods: greenMoods, color: .loginGreen)

        let redAndOrangeStack = createRowStack(with: [redStack, orangeStack])
        let blueAndGreenStack = createRowStack(with: [blueStack, greenStack])

        let mainStack = createMainVerticalStack(with: [redAndOrangeStack, blueAndGreenStack])
        addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Private Methods

    private func createMoodColorStack(moods: [String], color: UIColor) -> UIStackView {
        let firstRowStack = UIStackView()
        firstRowStack.axis = .horizontal
        firstRowStack.alignment = .center
        firstRowStack.spacing = 4
        firstRowStack.distribution = .equalSpacing

        for mood in moods.prefix(2) {
            let button = MoodCircle(moodLabel: mood, color: color)
            button.addTarget(self, action: #selector(moodButtonTapped(_:)), for: .touchUpInside)
            firstRowStack.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.width.height.equalTo(112)
            }
        }

        let secondRowStack = UIStackView()
        secondRowStack.axis = .horizontal
        secondRowStack.alignment = .center
        secondRowStack.spacing = 4
        secondRowStack.distribution = .equalSpacing

        for mood in moods.suffix(2) {
            let button = MoodCircle(moodLabel: mood, color: color)
            button.addTarget(self, action: #selector(moodButtonTapped(_:)), for: .touchUpInside)
            secondRowStack.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.width.height.equalTo(112)
            }
        }

        let verticalStack = UIStackView(arrangedSubviews: [firstRowStack, secondRowStack])
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.spacing = 4
        verticalStack.distribution = .equalSpacing
        return verticalStack
    }

    private func createRowStack(with moodGroupStacks: [UIStackView]) -> UIStackView {
        let rowStack = UIStackView(arrangedSubviews: moodGroupStacks)
        rowStack.axis = .horizontal
        rowStack.spacing = 4
        rowStack.alignment = .center
        rowStack.distribution = .equalSpacing
        return rowStack
    }

    private func createMainVerticalStack(with moodGroupStacks: [UIStackView]) -> UIStackView {
        let mainStack = UIStackView(arrangedSubviews: moodGroupStacks)
        mainStack.axis = .vertical
        mainStack.spacing = 4
        mainStack.alignment = .center
        mainStack.distribution = .equalSpacing
        return mainStack
    }

    // MARK: - Actions

    @objc private func moodButtonTapped(_ sender: MoodCircle) {
        if let mood = sender.title(for: .normal) {
            onMoodSelected?(sender.backgroundColor ?? .white, mood)
        }
    }
}

