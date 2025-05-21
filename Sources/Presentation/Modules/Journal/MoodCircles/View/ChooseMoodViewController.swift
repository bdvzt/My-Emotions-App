//
//  ChooseMoodViewController.swift
//  LAB1
//
//  Created by Zayata Budaeva on 26.02.2025.
//

import UIKit
import SnapKit

class ChooseMoodViewController: UIViewController {

    let chooseMoodViewModel: ChooseMoodViewModel

    // MARK: - Private properties
    private let scrollView = UIScrollView()
    private let backArrow = BackArrow()
    private let moodGrid = MoodGridView()
    private let moodCardContainer = UIView()
    private var currentMoodCard: ChosenMoodCard?

    // MARK: - Init
    init(
        chooseMoodViewModel: ChooseMoodViewModel,
        currentMoodCard: ChosenMoodCard? = nil
    ) {
        self.chooseMoodViewModel = chooseMoodViewModel
        self.currentMoodCard = currentMoodCard
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Setup

    private func setup() {
        view.backgroundColor = .black
        setupBackArrow()
        setupCard()
        setupScrollView()
        setupMoodGrid()
    }

    private func setupBackArrow() {
        view.addSubview(backArrow)
        backArrow.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        backArrow.addTarget(self, action: #selector(backArrowTapped), for: .touchUpInside)
        navigationItem.hidesBackButton = true
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

        moodGrid.configure(with: chooseMoodViewModel.moods)

        if let preselected = chooseMoodViewModel.selectedMood {
            showSelectedMood(preselected)
        }

        moodGrid.onMoodSelected = { [weak self] mood in
            guard let self = self else { return }
            self.chooseMoodViewModel.didTapMoodCircle(mood)
            self.showSelectedMood(mood)
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
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(arrowTapped))
            chosenCard.arrowView.addGestureRecognizer(tapGesture)
            currentMoodCard = chosenCard
        }
    }

    // MARK: - Actions

    private func showSelectedMood(_ mood: Mood) {
        let card = ChosenMoodCard(mood: mood)
        addMoodCard(card)
    }

    @objc private func backArrowTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func arrowTapped() {
        chooseMoodViewModel.didTapArrow()
    }
}
