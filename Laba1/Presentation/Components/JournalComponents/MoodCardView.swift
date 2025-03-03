//
//  MoodCardView.swift
//  LAB1
//
//  Created by Zayata Budaeva on 20.02.2025.
//

import UIKit
import SnapKit

final class MoodCardView: UIView {
    // MARK: - UI Elements

    private var gradientLayer: CAGradientLayer?

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 14)
        label.textColor = .white
        return label
    }()

    private let iFeelLabel: UILabel = {
        let label = UILabel()
        label.text = "Я чувствую"
        label.font = UIFont(name: "VelaSans-Regular", size: 20)
        label.textColor = .white
        return label
    }()

    private let moodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gwen-Trial-Bold", size: 28)
        return label
    }()

    private let moodIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()

    private let moodStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 3
        stack.alignment = .leading
        return stack
    }()

    // MARK: - Inits

    init(color: UIColor, image: UIImage?, dateText: String, moodText: String) {
        super.init(frame: .zero)
        layer.cornerRadius = 16
        clipsToBounds = true
        setup(color: color, dateText: dateText, moodText: moodText, image: image)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(color: UIColor, dateText: String, moodText: String, image: UIImage?) {
        dateLabel.text = dateText
        addSubview(dateLabel)

        moodLabel.text = moodText
        moodLabel.textColor = color
        moodIcon.image = image

        moodStackView.addArrangedSubview(iFeelLabel)
        moodStackView.addArrangedSubview(moodLabel)

        bottomStackView.addArrangedSubview(moodStackView)
        bottomStackView.addArrangedSubview(moodIcon)
        addSubview(bottomStackView)

        setupConstraints()
        setupGradient(color: color)
    }

    private func setupConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
        }

        bottomStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        }

        moodIcon.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.trailing.equalToSuperview().inset(10)
        }
    }

    private func setupGradient(color: UIColor) {
        gradientLayer?.removeFromSuperlayer()

        let newGradientLayer = CAGradientLayer()
        newGradientLayer.masksToBounds = true
        newGradientLayer.startPoint = CGPoint(x: 0, y: 1)
        newGradientLayer.endPoint = CGPoint(x: 1, y: 0)
        newGradientLayer.locations = [0.0, 1.0]

        switch color {
        case .loginOrange:
            newGradientLayer.colors = [UIColor.feelingGradientBlack.cgColor, UIColor.feelingGradientOrange.cgColor]
        case .loginRed:
            newGradientLayer.colors = [UIColor.feelingGradientBlack.cgColor, UIColor.feelingGradientRed.cgColor]
        case .loginBlue:
            newGradientLayer.colors = [UIColor.feelingGradientBlack.cgColor, UIColor.feelingGradientBlue.cgColor]
        case .loginGreen:
            newGradientLayer.colors = [UIColor.feelingGradientBlack.cgColor, UIColor.feelingGradientGreen.cgColor]
        default:
            newGradientLayer.colors = [UIColor.black.cgColor, UIColor.feelingGradientOrange.cgColor]
        }

        layer.insertSublayer(newGradientLayer, at: 0)
        gradientLayer = newGradientLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
}

#Preview {
    let cardView = MoodCardView(
        color: .loginOrange,
        image: UIImage(systemName: "sun.max.fill"),
        dateText: "вчера, 23:40",
        moodText: "счастье"
    )

    cardView.frame = CGRect(x: 0, y: 0, width: 364, height: 158)

    return cardView
}
