//
//  ChosenMoodCard.swift
//  LAB1
//
//  Created by Zayata Budaeva on 26.02.2025.
//

import UIKit
import SnapKit

final class ChosenMoodCard: UIView {

    // MARK: - Private properties

    private let moodColor: UIColor
    private let moodName: String

    private let chosenMoodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 12)
        label.textAlignment = .left
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 12)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    private let moodStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()

    private let arrowView: RightArrow = {
        let view = RightArrow(chosen: true)
        return view
    }()

    // MARK: - Init

    init(color: UIColor, mood: String, description: String) {
        self.moodColor = color
        self.moodName = mood
        super.init(frame: .zero)
        setup(color: color, mood: mood, description: description)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(color: UIColor, mood: String, description: String) {
        setupBackground()
        setupLabels(color: color, mood: mood, description: description)
        setupStackView()
    }

    private func setupBackground() {
        backgroundColor = .tabBar
        layer.cornerRadius = 40
    }

    private func setupLabels(color: UIColor, mood: String, description: String) {
        chosenMoodLabel.text = mood
        chosenMoodLabel.textColor = color

        descriptionLabel.text = description

        moodStackView.addArrangedSubview(chosenMoodLabel)
        moodStackView.addArrangedSubview(descriptionLabel)
    }

    private func setupStackView() {
        addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(moodStackView)
        horizontalStackView.addArrangedSubview(arrowView)

        horizontalStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-10)
            make.top.bottom.equalToSuperview().inset(10)
        }

        arrowView.snp.makeConstraints { make in
            make.width.height.equalTo(64)
        }

        arrowView.addTarget(self, action: #selector(arrowTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    //    @objc private func arrowTapped() {
    //        guard let parentVC = findViewController() else { return }
    //
    //        let addNoteVC = AddNoteViewController()
    //        addNoteVC.setupMoodCard(color: self.moodColor, mood: self.moodName)
    //        addNoteVC.isModalInPresentation = true
    //        addNoteVC.modalPresentationStyle = .fullScreen
    //
    //        parentVC.dismiss(animated: false) {
    //            parentVC.present(addNoteVC, animated: true)
    //        }
    //    }
    //
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let next = responder?.next {
            if let vc = next as? UIViewController {
                return vc
            }
            responder = next
        }
        return nil
    }
    
    @objc private func arrowTapped() {
        guard let parentVC = findViewController() else { return }

        let addNoteVC = AddNoteViewController()
        addNoteVC.setupMoodCard(color: self.moodColor, mood: self.moodName)
        addNoteVC.isModalInPresentation = true

        parentVC.navigationController?.pushViewController(addNoteVC, animated: true)
    }
}
