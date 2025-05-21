//
//  MoodGridView.swift
//  LAB1
//
//  Created by Zayata Budaeva on 26.02.2025.
//

import UIKit
import SnapKit

final class MoodGridView: UIView {
    var onMoodSelected: ((Mood) -> Void)?
    private var moodButtons: [MoodCircle] = []
    private var moods: [Mood] = []

    func configure(with moods: [Mood]) {
        self.moods = moods

        subviews.forEach { $0.removeFromSuperview() }
        moodButtons.removeAll()

        let rows = moods.chunked(into: 4)
        let rowStacks = rows.map { row in
            let stack = UIStackView(arrangedSubviews:
                                        row.map { mood in
                let button = MoodCircle(moodLabel: mood.title, color: mood.uiColor)
                button.tag = moodButtons.count
                button.addTarget(self, action: #selector(moodButtonTapped(_:)), for: .touchUpInside)
                button.snp.makeConstraints { make in
                    make.width.height.equalTo(112)
                }
                moodButtons.append(button)
                return button
            }
            )
            stack.axis = .horizontal
            stack.spacing = 8
            stack.distribution = .equalSpacing
            return stack
        }

        let mainStack = UIStackView(arrangedSubviews: rowStacks)
        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.distribution = .equalSpacing

        addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc private func moodButtonTapped(_ sender: MoodCircle) {
        let index = sender.tag
        guard moodButtons.indices.contains(index) else { return }
        let mood = moods[index]
        onMoodSelected?(mood)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
