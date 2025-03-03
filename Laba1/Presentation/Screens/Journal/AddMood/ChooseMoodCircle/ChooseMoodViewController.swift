//
//  ChooseMoodViewController.swift
//  LAB1
//
//  Created by Zayata Budaeva on 26.02.2025.
//

import UIKit
import SnapKit

class ChooseMoodViewController: UIViewController {

    // MARK: - Private properties
    var onSelected: ((UIColor, String) -> Void)?

    private let scrollView = UIScrollView()
    private let backArrow = BackArrow()
    private let moodGrid = MoodGridView()
    private let moodCardContainer = UIView()
    private var currentMoodCard: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        view.backgroundColor = .black
        setupBackArrow()
        setupCard()
        setupScrollView()
        setupMoodGrid()

        moodGrid.onMoodSelected = { [weak self] color, mood in
            self?.updateMoodCard(color: color, mood: mood)
        }
    }

    private func setupBackArrow() {
        view.addSubview(backArrow)
        backArrow.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
    }

    private func setupCard() {
        view.addSubview(moodCardContainer)
        moodCardContainer.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(80)
        }
        setNotChosenMoodCard()
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.alwaysBounceHorizontal = true

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(backArrow.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(moodCardContainer.snp.top).offset(-20)
        }
    }

    private func setupMoodGrid() {
        scrollView.addSubview(moodGrid)

        moodGrid.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            make.centerY.equalToSuperview()
            make.width.equalTo(500)
        }
    }

    private func setNotChosenMoodCard() {
        let notChosenMoodCard = NotChosenMoodCard()
        addMoodCard(notChosenMoodCard)
    }

    private func addMoodCard(_ newCard: UIView) {
        currentMoodCard?.removeFromSuperview()
        moodCardContainer.addSubview(newCard)
        newCard.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        currentMoodCard = newCard
    }

    // MARK: - Actions

    private func updateMoodCard(color: UIColor, mood: String) {
        let chosenCard = ChosenMoodCard(color: color, mood: mood, description: "Вы выбрали это настроение.")
        addMoodCard(chosenCard)

        let addNoteVC = AddNoteViewController()
        addNoteVC.setupMoodCard(color: color, mood: mood)

        addNoteVC.saveMoodCard = { [weak self] selectedColor, selectedMood in
            self?.onSelected?(selectedColor, selectedMood)
        }

        addNoteVC.modalPresentationStyle = .fullScreen
        present(addNoteVC, animated: true)
    }
}

#Preview {
    ChooseMoodViewController()
}
