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

    private let maxHeight: CGFloat = 450
    private let gradientLayer = CAGradientLayer()
    private var heightConstraint: Constraint?
    private let columnContainer = UIView()

    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Bold", size: 12)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 12)
        label.textColor = .tabBarUnselected
        label.textAlignment = .center
        return label
    }()

    // MARK: - Public properties

    var moodCase: EmotionColor = .none {
        didSet {
            setupGradient()
        }
    }

    var percentage: CGFloat = 0 {
        didSet {
            updateHeight()
            percentageLabel.text = "\(Int(percentage))%"
        }
    }

    var partOfDayLabel: String = "" {
        didSet {
            bottomLabel.text = partOfDayLabel
        }
    }

    var amount: Int = 0 {
        didSet {
            amountLabel.text = "\(amount)"
        }
    }

    // MARK: - Инициализаторы

    init(moodCase: EmotionColor = .none,
         percentage: CGFloat = 0,
         title: String = "",
         amount: Int = 0) {
        self.moodCase = moodCase
        self.percentage = percentage
        self.partOfDayLabel = title
        super.init(frame: .zero)
        setup()

        bottomLabel.text = title
        amountLabel.text = "\(amount)"
        percentageLabel.text = "\(Int(percentage))%"
        setupGradient()
        updateHeight()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.spacing = 8
        addSubview(mainStack)

        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        mainStack.addArrangedSubview(columnContainer)
        columnContainer.layer.insertSublayer(gradientLayer, at: 0)
        columnContainer.layer.cornerRadius = 8
        columnContainer.layer.masksToBounds = true

        columnContainer.snp.makeConstraints { make in
            make.width.equalTo(66)
        }

        columnContainer.addSubview(percentageLabel)
        percentageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        let bottomStack = UIStackView()
        bottomStack.axis = .vertical
        bottomStack.alignment = .center
        bottomStack.spacing = 4

        bottomStack.addArrangedSubview(bottomLabel)
        bottomStack.addArrangedSubview(amountLabel)

        mainStack.addArrangedSubview(bottomStack)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = columnContainer.bounds
    }

    // MARK: - Private methods

    private func updateHeight() {
        let checkedHeight = max(min(percentage, 100), 0)
        let newHeight = maxHeight * (checkedHeight / 100.0)

        if let heightConstraint = heightConstraint {
            heightConstraint.update(offset: newHeight)
        } else {
            columnContainer.snp.makeConstraints { make in
                self.heightConstraint = make.height.equalTo(newHeight).constraint
            }
        }
    }

    private func setupGradient() {
        if moodCase == .none {
            columnContainer.backgroundColor = .tabBar
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
            return
        }
        let (color1, color2) = chooseGradientColors(moodCase)
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint   = CGPoint(x: 1, y: 0.5)
    }

    private func chooseGradientColors(_ mood: EmotionColor) -> (UIColor, UIColor) {
        switch mood {
        case .red:
            return (.feelingGradientRed, .redGradient)
        case .blue:
            return (.feelingGradientBlue, .blueGradient)
        case .yellow:
            return (.feelingGradientOrange, .orangeGradient)
        case .green:
            return (.feelingGradientGreen, .greenGradient)
        case .none:
            return (.clear, .clear)
        }
    }
}
