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

    private let scrollView = UIScrollView()
    private let backArrow = BackArrow()
    private let moodGrid = MoodGridView()
    private let moodCardContainer = UIView()
    private var currentMoodCard: ChosenMoodCard?

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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        backArrow.addTarget(self, action: #selector(backArrowTapped), for: .touchUpInside)
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

        if let chosenCard = newCard as? ChosenMoodCard {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextMoodTapped))
            chosenCard.arrowView.addGestureRecognizer(tapGesture)
            currentMoodCard = chosenCard
        }
    }

    // MARK: - Actions

    @objc private func backArrowTapped() {
        let journalViewController = TabController()
        let navController = UINavigationController(rootViewController: journalViewController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: false)
    }

    private func updateMoodCard(color: UIColor, mood: String) {
        let chosenCard = ChosenMoodCard(color: color, mood: mood, description: "ощущение, что необходимо отдохнуть")
        addMoodCard(chosenCard)
    }

    @objc private func nextMoodTapped() {
        guard let chosenCard = currentMoodCard else { return }

        let addNoteVC = AddNoteViewController(color: chosenCard.moodColor, mood: chosenCard.moodName)

        addNoteVC.modalPresentationStyle = .fullScreen
        present(addNoteVC, animated: false)
    }
}

#Preview {
    ChooseMoodViewController()
}
