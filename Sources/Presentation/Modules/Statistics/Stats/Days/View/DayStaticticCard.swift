//
//  DayStaticticCard.swift
//  LAB1
//
//  Created by Zayata Budaeva on 28.02.2025.
//

import UIKit
import SnapKit

final class DayStaticsticCard: UIView {

    // MARK: - Private UI

    private let horizontalStackView = UIStackView()
    private let dateStackView = UIStackView()
    private let labelsStackView = UIStackView()

    private let dayLabel = UILabel()
    private let dateLabel = UILabel()
    private let bottomLine = UIView()

    private var images: [UIImage] = []
    private let moodsTitles: [String]

    private let moodCollectionView: UICollectionView

    // MARK: - Init

    init(day: String, date: String, moodsTitles: [String], moodsImages: [UIImage]) {
        self.moodsTitles = moodsTitles
        self.images = moodsImages
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.sectionInset = .zero
        layout.estimatedItemSize = CGSize(width: 24, height: 24)

        self.moodCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: .zero)
        setup(day: day, date: date)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(day: String, date: String) {
        backgroundColor = .black

        addSubview(horizontalStackView)
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 8
        horizontalStackView.alignment = .top
        horizontalStackView.distribution = .fill
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview()
        }

        // MARK: - Date stack
        dateLabel.font = UIFont(name: "VelaSans-Regular", size: 12)
        dayLabel.font = UIFont(name: "VelaSans-Regular", size: 12)
        dateLabel.textColor = .white
        dayLabel.textColor = .white
        dayLabel.text = day
        dateLabel.text = date

        dateStackView.axis = .vertical
        dateStackView.spacing = 2
        dateStackView.alignment = .leading
        dateStackView.addArrangedSubview(dayLabel)
        dateStackView.addArrangedSubview(dateLabel)

        horizontalStackView.addArrangedSubview(dateStackView)
        dateStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }

        // MARK: - Labels stack
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 4
        labelsStackView.alignment = .leading

        for title in moodsTitles {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont(name: "VelaSans-Regular", size: 12)
            titleLabel.textColor = .tabBarUnselected
            titleLabel.numberOfLines = 0
            labelsStackView.addArrangedSubview(titleLabel)
        }

        horizontalStackView.addArrangedSubview(labelsStackView)
        labelsStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.4)
        }

        let spacer = UIView()
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        spacer.setContentHuggingPriority(.defaultLow,  for: .horizontal)
        horizontalStackView.addArrangedSubview(spacer)

        // MARK: - Icon collection
        moodCollectionView.backgroundColor = .clear
        moodCollectionView.isScrollEnabled = false
        moodCollectionView.dataSource = self
        moodCollectionView.delegate = self
        moodCollectionView.register(MoodIconCell.self, forCellWithReuseIdentifier: "MoodIconCell")
        moodCollectionView.reloadData()

        horizontalStackView.addArrangedSubview(moodCollectionView)
        moodCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.greaterThanOrEqualTo(50)
        }

        // MARK: - Bottom line
        addSubview(bottomLine)
        bottomLine.backgroundColor = .amountGray
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension DayStaticsticCard: UICollectionViewDataSource {
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(images.count, 1)
    }

    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "MoodIconCell", for: indexPath) as! MoodIconCell
        let image = images.isEmpty ? .emptyCircle : images[indexPath.item]
        cell.setImage(image)
        return cell
    }
}

extension DayStaticsticCard: UICollectionViewDelegateFlowLayout {
    func collectionView(_ cv: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if images.isEmpty {
            return CGSize(width: 40, height: 40)
        }
        return CGSize(width: 24, height: 24)
    }
}
