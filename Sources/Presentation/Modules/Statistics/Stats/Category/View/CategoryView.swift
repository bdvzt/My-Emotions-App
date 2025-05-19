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

        var circles: [MoodPerCentCircle] = []

        let containerWidth = circlesContainerView.bounds.width
        let containerHeight = circlesContainerView.bounds.height

        let availableSide = min(containerWidth, containerHeight)
        let maxCircleSize = availableSide * 0.9
        let minCircleSize = availableSide * 0.2

        func addCircle(percent: Int, colors: (UIColor, UIColor)) {
            guard percent > 0 else { return }

            let rawSize = maxCircleSize * CGFloat(percent) / 100.0
            let size = max(minCircleSize, rawSize)

            let circle = MoodPerCentCircle(size: size, colors: colors, percent: percent)
            circles.append(circle)
        }

        addCircle(percent: viewModel.redPercent, colors: (.redGradient, .feelingGradientRed))
        addCircle(percent: viewModel.bluePercent, colors: (.blueGradient, .feelingGradientBlue))
        addCircle(percent: viewModel.greenPercent, colors: (.greenGradient, .feelingGradientGreen))
        addCircle(percent: viewModel.orangePercent, colors: (.orangeGradient, .feelingGradientOrange))

        circles.sort { $0.intrinsicContentSize.width > $1.intrinsicContentSize.width }

        let layoutView = UIView()
        circlesContainerView.addSubview(layoutView)
        layoutView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }

        let offsets: [CGPoint] = [
            CGPoint(x: -maxCircleSize * 0.25, y: -maxCircleSize * 0.25),
            CGPoint(x: maxCircleSize * 0.25, y: -maxCircleSize * 0.25),
            CGPoint(x: -maxCircleSize * 0.25, y: maxCircleSize * 0.25),
            CGPoint(x: maxCircleSize * 0.25, y: maxCircleSize * 0.25)
        ]

        for (index, circle) in circles.enumerated() {
            layoutView.addSubview(circle)
            layoutView.sendSubviewToBack(circle)

            let offset = index < offsets.count ? offsets[index] : .zero
            circle.snp.makeConstraints { make in
                make.centerX.equalToSuperview().offset(offset.x)
                make.centerY.equalToSuperview().offset(offset.y)
            }
        }
    }

    //    private func setupCircles() {
    //        var circles: [MoodPerCentCircle] = []
    //
    //        if redPercent > 0 {
    //            let size = maxCircleSize * CGFloat(redPercent) / 100.0
    //            let circle = MoodPerCentCircle(size: size, colors: (.redGradient, .feelingGradientRed), percent: redPercent)
    //            circles.append(circle)
    //        }
    //        if bluePercent > 0 {
    //            let size = maxCircleSize * CGFloat(bluePercent) / 100.0
    //            let circle = MoodPerCentCircle(size: size, colors: (.blueGradient, .feelingGradientBlue), percent: bluePercent)
    //            circles.append(circle)
    //        }
    //        if greenPercent > 0 {
    //            let size = maxCircleSize * CGFloat(greenPercent) / 100.0
    //            let circle = MoodPerCentCircle(size: size, colors: (.greenGradient, .feelingGradientGreen), percent: greenPercent)
    //            circles.append(circle)
    //        }
    //        if orangePercent > 0 {
    //            let size = maxCircleSize * CGFloat(orangePercent) / 100.0
    //            let circle = MoodPerCentCircle(size: size, colors: (.orangeGradient, .feelingGradientOrange), percent: orangePercent)
    //            circles.append(circle)
    //        }
    //
    //            let view1 = UIView()
    //            circlesContainerView.addSubview(view1)
    //
    //            view1.snp.makeConstraints { make in
    //                make.center.equalToSuperview()
    //            }
    //
    //            var viewSize: CGFloat
    //
    //            for circle in circles {
    //                view1.addSubview(circle)
    //            }
    //
    //            switch circles.count {
    //            case 1:
    //                let circle = circles[0]
    //                circle.snp.makeConstraints { make in
    //                    make.center.equalToSuperview()
    //                }
    //            case 2:
    //                let circle0 = circles[0]
    //                let circle1 = circles[1]
    //
    //                circle0.snp.makeConstraints { make in
    //                    make.centerX.equalToSuperview().offset(-40)
    //                    make.centerY.equalToSuperview().offset(-40)
    //                }
    //
    //                circle1.snp.makeConstraints { make in
    //                    make.centerX.equalToSuperview().offset(30)
    //                    make.centerY.equalToSuperview().offset(40)
    //                }
    //
    //                viewSize = circle0.intrinsicContentSize.width + circle1.intrinsicContentSize.width - 80
    //                view1.snp.makeConstraints { make in
    //                    make.width.height.equalTo(viewSize)
    //                }
    //            case 3:
    //                let circle0 = circles[0]
    //                let circle1 = circles[1]
    //                let circle2 = circles[2]
    //
    //                circle0.snp.makeConstraints { make in
    //                    make.top.equalToSuperview()
    //                    make.centerX.equalToSuperview()
    //                }
    //                circle1.snp.makeConstraints { make in
    //                    make.bottom.equalToSuperview()
    //                    make.leading.equalToSuperview()
    //                }
    //                circle2.snp.makeConstraints { make in
    //                    make.bottom.equalToSuperview()
    //                    make.trailing.equalToSuperview()
    //                }
    //            case 4:
    //                let circle0 = circles[0]
    //                let circle1 = circles[1]
    //                let circle2 = circles[2]
    //                let circle3 = circles[3]
    //
    //                circle0.snp.makeConstraints { make in
    //                    make.top.leading.equalToSuperview()
    //                }
    //                circle1.snp.makeConstraints { make in
    //                    make.top.trailing.equalToSuperview()
    //                }
    //                circle2.snp.makeConstraints { make in
    //                    make.bottom.leading.equalToSuperview()
    //                }
    //                circle3.snp.makeConstraints { make in
    //                    make.bottom.trailing.equalToSuperview()
    //                }
    //            default:
    //                break
    //            }
    //        }
}

