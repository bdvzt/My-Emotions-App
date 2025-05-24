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
    private let viewModel: CategoryStatisticsViewModel
    private var didSetupCircles = false

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

    init(viewModel: CategoryStatisticsViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()

        if !didSetupCircles {
            didSetupCircles = true
            setupCircles()
        }
    }

    // MARK: - Setup

    private func setup() {
        setupTitleLabel()
        setupAmountOfNotesLabel()
        setupCirclesContainer()
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }

    private func setupAmountOfNotesLabel() {
        addSubview(amountOfNotesLabel)
        amountOfNotesLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        let total = viewModel.amountOfNotes
        let notesText = getNotesText(for: total)
        amountOfNotesLabel.text = "\(total) \(notesText)"
    }

    private func setupCirclesContainer() {
        addSubview(circlesContainerView)

        let screenHeight = UIScreen.main.bounds.height
        let containerHeight = screenHeight * 0.45

        circlesContainerView.snp.makeConstraints { make in
            make.top.equalTo(amountOfNotesLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(containerHeight)
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
        layoutIfNeeded()

        let containerWidth = circlesContainerView.bounds.width
        let containerHeight = circlesContainerView.bounds.height
        let availableSide = min(containerWidth, containerHeight)
        let maxCircleSize = availableSide * 0.9
        let minCircleSize = availableSide * 0.2

        var circles: [MoodPerCentCircle] = []

        func addCircle(percent: Int, colors: (UIColor, UIColor)) {
            guard percent > 0 else { return }
            let rawSize = maxCircleSize * CGFloat(percent) / 100.0
            let size = max(minCircleSize, rawSize)
            let circle = MoodPerCentCircle(size: size, colors: colors, percent: percent)
            circles.append(circle)
        }

        addCircle(percent: viewModel.redPercent, colors: (.redGradient, .feelingGradientRed))
        addCircle(percent: viewModel.orangePercent, colors: (.orangeGradient, .feelingGradientOrange))
        addCircle(percent: viewModel.bluePercent, colors: (.blueGradient, .feelingGradientBlue))
        addCircle(percent: viewModel.greenPercent, colors: (.greenGradient, .feelingGradientGreen))

        circles.sort { $0.intrinsicContentSize.width > $1.intrinsicContentSize.width }

        let layoutView = UIView()
        circlesContainerView.addSubview(layoutView)

        let layoutSize: CGFloat = max(circles.first?.intrinsicContentSize.width ?? 0, maxCircleSize)
        layoutView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(layoutSize)
        }

        switch circles.count {
        case 1:
            let circle = circles[0]
            layoutView.addSubview(circle)
            circle.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }

        case 2:
            let big = circles[0]
            let small = circles[1]

            layoutView.addSubview(big)
            layoutView.addSubview(small)

            let bigWidth = big.intrinsicContentSize.width
            let smallWidth = small.intrinsicContentSize.width

            let totalWidth = bigWidth + smallWidth
            let bigOffset = (smallWidth / totalWidth) * maxCircleSize * 0.4
            let smallOffset = (bigWidth / totalWidth) * maxCircleSize * 0.4

            big.snp.makeConstraints { make in
                make.centerX.equalToSuperview().offset(-bigOffset)
                make.centerY.equalToSuperview()
            }

            small.snp.makeConstraints { make in
                make.centerX.equalToSuperview().offset(smallOffset)
                make.centerY.equalToSuperview().offset(maxCircleSize * 0.3)
            }

        case 3:
            layoutView.addSubview(circles[0])
            layoutView.addSubview(circles[1])
            layoutView.addSubview(circles[2])

            circles[0].snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
            }

            circles[1].snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview()
            }

            circles[2].snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.trailing.equalToSuperview()
            }

        case 4:
            layoutView.addSubview(circles[0])
            layoutView.addSubview(circles[1])
            layoutView.addSubview(circles[2])
            layoutView.addSubview(circles[3])

            circles[0].snp.makeConstraints { make in
                make.top.leading.equalToSuperview()
            }

            circles[1].snp.makeConstraints { make in
                make.top.trailing.equalToSuperview()
            }

            circles[2].snp.makeConstraints { make in
                make.bottom.leading.equalToSuperview()
            }

            circles[3].snp.makeConstraints { make in
                make.bottom.trailing.equalToSuperview()
            }

        default:
            for circle in circles {
                layoutView.addSubview(circle)
                circle.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
            }
        }

        for circle in circles {
            layoutView.sendSubviewToBack(circle)
        }
    }
}

