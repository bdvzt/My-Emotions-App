//
//  FrequencyStatistics.swift
//  LAB1
//
//  Created by Zayata Budaeva on 02.03.2025.
//

import UIKit
import SnapKit

final class FrequencyStatistics: UIView {

    // MARK: - Private properties

    private let firstColor: UIColor
    private let secondColor: UIColor
    private let perCent: Int

    private let gradientLayer = CAGradientLayer()
    private let filledView = UIView()
    private let amount: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Bold", size: 14)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    // MARK: - Init

    init(firstColor: UIColor, secondColor: UIColor, perCent: Int, frame: CGRect = .zero) {
        self.firstColor = firstColor
        self.secondColor = secondColor
        self.perCent = min(max(perCent, 0), 100)
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        layer.cornerRadius = 10
//        layer.masksToBounds = true
        layer.masksToBounds = false

        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(gradientLayer)

        filledView.backgroundColor = .clear
        addSubview(filledView)

        amount.text = "\(perCent)"
        addSubview(amount)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
        gradientLayer.setNeedsDisplay()

        let width = bounds.width * CGFloat(perCent) / 100
        filledView.frame = CGRect(x: 0, y: 0, width: width, height: bounds.height)

        amount.frame = bounds
    }
}
