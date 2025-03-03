//
//  DayStaticticCard.swift
//  LAB1
//
//  Created by Zayata Budaeva on 28.02.2025.
//

import UIKit
import SnapKit

final class DayStaticsticCard: UIView {

    // MARK: - Private properties

    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()

    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 2
        return stackView
    }()

    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 12)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 12)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    private let moodStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()

    private let moodImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()

    private let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .amountGray
        return view
    }()

    // MARK: - Inits

    init(day: String, date: String, moodsTitles: [String], moodsImages: [UIImage]) {
        super.init(frame: .zero)
        setup()
        configure(day: day, date: date, moodsTitles: moodsTitles, moodsImages: moodsImages)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .black
        addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        setupDateStack()
        setupMoodStack()
        setupBottomLine()
    }

    private func setupDateStack() {
        dateStackView.addArrangedSubview(dayLabel)
        dateStackView.addArrangedSubview(dateLabel)
    }

    private func setupMoodStack() {
        horizontalStackView.addArrangedSubview(dateStackView)
        horizontalStackView.addArrangedSubview(moodStackView)
        horizontalStackView.addArrangedSubview(moodImageStackView)
    }

    private func setupBottomLine() {
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    // MARK: - Configuration

    private func configure(day: String, date: String, moodsTitles: [String], moodsImages: [UIImage]) {
        dayLabel.text = day
        dateLabel.text = date

        addMoodTitles(titles: moodsTitles)
        addMoodImages(images: moodsImages)
    }

    private func addMoodTitles(titles: [String]) {
        for title in titles {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont(name: "VelaSans-Regular", size: 12)
            titleLabel.textColor = .tabBarUnselected
            titleLabel.textAlignment = .left
            moodStackView.addArrangedSubview(titleLabel)
        }
    }

    private func addMoodImages(images: [UIImage]) {
        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            moodImageStackView.addArrangedSubview(imageView)
        }
    }
}
