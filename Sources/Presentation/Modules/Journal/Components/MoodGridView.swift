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
    private var moodMap: [UIButton: Mood] = [:]
    
    func configure(with moods: [Mood]) {
        self.moods = moods
        
        subviews.forEach { $0.removeFromSuperview() }
        moodButtons.removeAll()
        
        let orderedColors: [MoodColorType] = [.red, .orange, .blue, .green]
        let grouped = Dictionary(grouping: moods, by: { $0.colorType })
        
        let colorStacks: [UIStackView] = orderedColors.compactMap { color in
            guard let group = grouped[color] else { return nil }
            
            let firstRow = UIStackView()
            let secondRow = UIStackView()
            
            [firstRow, secondRow].forEach {
                $0.axis = .horizontal
                $0.spacing = 8
                $0.alignment = .center
                $0.distribution = .equalSpacing
            }
            
            for (index, mood) in group.enumerated() {
                let button = MoodCircle(moodLabel: mood.title, color: mood.uiColor)
                moodMap[button] = mood
                button.addTarget(self, action: #selector(moodButtonTapped(_:)), for: .touchUpInside)
                button.snp.makeConstraints { make in
                    make.width.height.equalTo(112)
                }
                moodButtons.append(button)
                
                if index < 2 {
                    firstRow.addArrangedSubview(button)
                } else {
                    secondRow.addArrangedSubview(button)
                }
            }
            
            let verticalStack = UIStackView(arrangedSubviews: [firstRow, secondRow])
            verticalStack.axis = .vertical
            verticalStack.spacing = 8
            verticalStack.alignment = .center
            verticalStack.distribution = .equalSpacing
            
            return verticalStack
        }
        
        let firstRow = UIStackView(arrangedSubviews: Array(colorStacks.prefix(2)))
        let secondRow = UIStackView(arrangedSubviews: Array(colorStacks.suffix(2)))
        
        [firstRow, secondRow].forEach {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
            $0.distribution = .equalSpacing
        }
        
        let mainStack = UIStackView(arrangedSubviews: [firstRow, secondRow])
        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.alignment = .center
        mainStack.distribution = .equalSpacing
        
        addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func moodButtonTapped(_ sender: MoodCircle) {
        guard let mood = moodMap[sender] else { return }
        onMoodSelected?(mood)
    }
}

