//
//  ColorColumn.swift
//  LAB1
//
//  Created by Zayata Budaeva on 02.03.2025.
//

import UIKit
import SnapKit

final class ColorColumn: UIView {
    
    // MARK: - Private properties

    private let gradientLayer = CAGradientLayer()

    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Bold", size: 12)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    // MARK: - Public properties

    var moodCase: EmotionColor
    var percentage: CGFloat

    // MARK: - Inits

    init(moodCase: EmotionColor, percentage: CGFloat) {
        self.moodCase = moodCase
        self.percentage = percentage
        super.init(frame: .zero)
        setup()
        setupGradient()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.addSublayer(gradientLayer)

        addSubview(percentageLabel)
        percentageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        if moodCase == .none {
            percentageLabel.isHidden = true
        } else {
            percentageLabel.text = "\(Int(percentage))%"
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    // MARK: - Private methods

    private func setupGradient() {
        if moodCase == .none {
            backgroundColor = .tabBar
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
            return
        }

        let (color1, color2) = chooseGradientColors(moodCase)
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1.0)
        gradientLayer.frame = bounds
    }

    private func chooseGradientColors(_ mood: EmotionColor) -> (UIColor, UIColor) {
        switch mood {
        case .red:
            return (.feelingGradientRed, .redGradient)
        case .blue:
            return (.feelingGradientBlue, .blueGradient)
        case .orange:
            return (.feelingGradientOrange, .orangeGradient)
        case .green:
            return (.feelingGradientGreen, .greenGradient)
        case .none:
            return (.clear, .clear)
        }
    }
}
