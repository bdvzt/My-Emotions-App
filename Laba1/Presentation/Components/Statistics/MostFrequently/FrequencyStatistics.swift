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
    private let amount: Int

    private let gradientLayer = CAGradientLayer()
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Bold", size: 14)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    // MARK: - Init

    init(firstColor: UIColor, secondColor: UIColor, amount: Int) {
        self.firstColor = firstColor
        self.secondColor = secondColor
        self.amount = amount
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        layer.cornerRadius = 16
        clipsToBounds = true
        layer.masksToBounds = true

        amountLabel.text = "\(amount)"
        amountLabel.layer.zPosition = 1

        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 10
        layer.insertSublayer(gradientLayer, at: 0)

        addSubview(amountLabel)

        amountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
