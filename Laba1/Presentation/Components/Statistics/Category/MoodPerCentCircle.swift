//
//  MoodPerCentCircle.swift
//  LAB1
//
//  Created by Zayata Budaeva on 28.02.2025.
//

import UIKit
import SnapKit

final class MoodPerCentCircle: UIView {

    // MARK: - Private properties

    private let percentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()

    private var circleSize: CGFloat = 0
    private let gradientLayer = CAGradientLayer()

    // MARK: - Inits

    init(size: CGFloat, colors: (UIColor, UIColor), percent: Int) {
        super.init(frame: .zero)
        self.circleSize = size
        setupGradient(colors: colors)

        layer.cornerRadius = size / 2
        clipsToBounds = true

        percentLabel.text = "\(percent) %"
        addSubview(percentLabel)
        percentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: circleSize, height: circleSize)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = bounds.width / 2
    }

    // MARK: - Gradient Setup

    private func setupGradient(colors: (UIColor, UIColor)) {
        gradientLayer.colors = [colors.0.cgColor, colors.1.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
