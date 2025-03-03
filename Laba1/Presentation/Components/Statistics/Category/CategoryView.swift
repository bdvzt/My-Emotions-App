//
//  CategoryView.swift
//  LAB1
//
//  Created by Zayata Budaeva on 28.02.2025.
//

import UIKit
import SnapKit

final class CategoryView: UIView {

    // MARK: - Private properties

    private let maxCircleSize: CGFloat = 400

    private let redPercent: Int
    private let bluePercent: Int
    private let greenPercent: Int
    private let orangePercent: Int

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Эмоции \nпо категориям"
        label.font = UIFont(name: "Gwen-Trial-Regular", size: 36)
        label.textColor = .white
        return label
    }()

    private let amountOfNotesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "VelaSans-Regular", size: 20)
        label.textColor = .white
        return label
    }()

    private let circlesContainerView: UIView = {
        let view = UIView()
        return view
    }()

    // MARK: - Inits

    init(amountOfNotes: Int, redPercent: Int, bluePercent: Int, greenPercent: Int, orangePercent: Int) {
        self.redPercent = redPercent
        self.bluePercent = bluePercent
        self.greenPercent = greenPercent
        self.orangePercent = orangePercent
        super.init(frame: .zero)
        setup(amountOfNotes: amountOfNotes)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(amountOfNotes: Int) {
        setupTitleLabel()
        setupAmountOfNotesLabel(amountOfNotes: amountOfNotes)
        setupCirclesContainer()
        setupCircles()
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }

    private func setupAmountOfNotesLabel(amountOfNotes: Int) {
        addSubview(amountOfNotesLabel)
        amountOfNotesLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        let notesText = getNotesText(for: amountOfNotes)
        amountOfNotesLabel.text = "\(amountOfNotes) \(notesText)"
    }

    private func setupCirclesContainer() {
        addSubview(circlesContainerView)
        circlesContainerView.snp.makeConstraints { make in
            make.top.equalTo(amountOfNotesLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(500)
        }
    }

    private func getNotesText(for count: Int) -> String {
        let lastDigit = count % 10
        if lastDigit == 1 {
            return "запись"
        } else if (lastDigit >= 2 && lastDigit <= 4) {
            return "записи"
        } else {
            return "записей"
        }
    }

    private func setupCircles() {
        var circles: [MoodPerCentCircle] = []

        if redPercent > 0 {
            let size = maxCircleSize * CGFloat(redPercent) / 100.0
            let circle = MoodPerCentCircle(size: size, color: .loginRed, percent: redPercent)
            circles.append(circle)
        }
        if bluePercent > 0 {
            let size = maxCircleSize * CGFloat(bluePercent) / 100.0
            let circle = MoodPerCentCircle(size: size, color: .loginBlue, percent: bluePercent)
            circles.append(circle)
        }
        if greenPercent > 0 {
            let size = maxCircleSize * CGFloat(greenPercent) / 100.0
            let circle = MoodPerCentCircle(size: size, color: .loginGreen, percent: greenPercent)
            circles.append(circle)
        }
        if orangePercent > 0 {
            let size = maxCircleSize * CGFloat(orangePercent) / 100.0
            let circle = MoodPerCentCircle(size: size, color: .loginOrange, percent: orangePercent)
            circles.append(circle)
        }

        let view1 = UIView()
        circlesContainerView.addSubview(view1)

        view1.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        var viewSize: CGFloat

        for circle in circles {
            view1.addSubview(circle)
        }

        switch circles.count {
        case 1:
            let circle = circles[0]
            circle.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        case 2:
            let circle0 = circles[0]
            let circle1 = circles[1]

            circle0.snp.makeConstraints { make in
                make.centerX.equalToSuperview().offset(-40)
                make.centerY.equalToSuperview().offset(-40)
            }

            circle1.snp.makeConstraints { make in
                make.centerX.equalToSuperview().offset(30)
                make.centerY.equalToSuperview().offset(40)
            }

            viewSize = circle0.intrinsicContentSize.width + circle1.intrinsicContentSize.width - 80
            view1.snp.makeConstraints { make in
                make.width.height.equalTo(viewSize)
            }
        case 3:
            let circle0 = circles[0]
            let circle1 = circles[1]
            let circle2 = circles[2]

            circle0.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            circle1.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview()
            }
            circle2.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.trailing.equalToSuperview()
            }
        case 4:
            let circle0 = circles[0]
            let circle1 = circles[1]
            let circle2 = circles[2]
            let circle3 = circles[3]

            circle0.snp.makeConstraints { make in
                make.top.leading.equalToSuperview()
            }
            circle1.snp.makeConstraints { make in
                make.top.trailing.equalToSuperview()
            }
            circle2.snp.makeConstraints { make in
                make.bottom.leading.equalToSuperview()
            }
            circle3.snp.makeConstraints { make in
                make.bottom.trailing.equalToSuperview()
            }
        default:
            break
        }
    }
}

