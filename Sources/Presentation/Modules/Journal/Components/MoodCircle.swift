//
//  MoodCircle.swift
//  LAB1
//
//  Created by Zayata Budaeva on 26.02.2025.
//

import UIKit
import SnapKit

final class MoodCircle: UIButton {

    // MARK: - Inits

    init(moodLabel: String, color: UIColor) {
        super.init(frame: .zero)
        setup(moodLabel: moodLabel, color: color)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(moodLabel: String, color: UIColor) {
        setupCircleView(moodLabel: moodLabel, color: color)
    }

    private func setupCircleView(moodLabel: String, color: UIColor) {
        backgroundColor = color
        setTitle(moodLabel, for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont(name: "Gwen-Trial-Bold", size: 10)
        layer.cornerRadius = 56
        layer.masksToBounds = true
    }
}
