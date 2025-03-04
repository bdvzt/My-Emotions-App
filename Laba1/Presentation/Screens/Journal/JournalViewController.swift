//
//  JournalViewController.swift
//  LAB1
//
//  Created by Zayata Budaeva on 20.02.2025.
//

import UIKit
import SnapKit

class JournalViewController: UIViewController {

    // MARK: - Private properties

    //    private var moodCards: [MoodCardView] = []

    private var moodCards: [MoodCardView] = [
        MoodCardView(
            color: .loginBlue,
            image: .sadness,
            dateText: "вчера, 23:40",
            moodText: "выгорание"
        ),
        MoodCardView(
            color: .loginGreen,
            image: .greenMood,
            dateText: "вчера, 14:08",
            moodText: "спокойствие"),
        MoodCardView(
            color: .loginOrange,
            image: .lightning,
            dateText: "воскресенье, 16:12",
            moodText: "продуктивность"),
        MoodCardView(
            color: .loginRed,
            image: .redMood,
            dateText: "воскресенье, 03:59",
            moodText: "беспокойство")
    ]

    private let notesAmountStack = UIStackView()
    private let questionLabel = QuestionLabel()
    private let addMoodButton = AddMoodButton()
    private let cardsContainerView = UIView()
    private let moodCardScrollView = UIScrollView()
    private let circleProgressBar = CircleProgressBar()

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет записей о настроении"
        label.textColor = .white
        label.textAlignment = .center
        label.font =  UIFont(name: "VelaSans-Regular", size: 20)
        label.isHidden = true
        return label
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Ошибка загрузки данных"
        label.textColor = .white
        label.textAlignment = .center
        label.font =  UIFont(name: "VelaSans-Regular", size: 20)
        label.isHidden = true
        return label
    }()

    // MARK: - Inits

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "journalScreen"
        moodCardScrollView.accessibilityIdentifier = "moodCardScrollView"
        cardsContainerView.accessibilityIdentifier = "cardsContainerView"
        emptyStateLabel.accessibilityIdentifier = "emptyStateLabel"
        circleProgressBar.accessibilityIdentifier = "circleProgressBar"
        errorLabel.accessibilityIdentifier = "errorLabel"
        addMoodButton.accessibilityIdentifier = "addMoodButton"
        view.backgroundColor = .black
        setup()
    }

    // MARK: - Setup

    private func setup() {
        view.addSubview(emptyStateLabel)
        view.addSubview(errorLabel)
        setupNotesAmountStackView()
        setupQuestionLabel()
        setupScrollViewContent()
        setupAddMoodButtonAction()
        updateEmptyState()
        //        handleErrorState()

        emptyStateLabel.snp.makeConstraints { make in
            make.top.equalTo(circleProgressBar.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }

        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(circleProgressBar.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }

        self.perform(#selector(animateProgress), with: nil, afterDelay: 2.0)
    }

    @objc
    func animateProgress() {
        circleProgressBar.setProgressWithAnimation(duration: 1.0, value: 0.7)
    }

    private func setupNotesAmountStackView() {
        notesAmountStack.axis = .horizontal
        notesAmountStack.spacing = 8
        notesAmountStack.alignment = .fill
        notesAmountStack.distribution = .equalSpacing

        let totalAmount = NotesAmountCard(description: "", amount: "4 записи")
        let dayAmount = NotesAmountCard(description: "в день: ", amount: "2 записи")
        let streakAmount = NotesAmountCard(description: "серия: ", amount: "0 дней")

        notesAmountStack.addArrangedSubview(totalAmount)
        notesAmountStack.addArrangedSubview(dayAmount)
        notesAmountStack.addArrangedSubview(streakAmount)

        view.addSubview(notesAmountStack)

        notesAmountStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
        }
    }

    private func setupQuestionLabel() {
        view.addSubview(questionLabel)

        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(notesAmountStack.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
        }
    }

    private func setupScrollViewContent() {
        view.addSubview(moodCardScrollView)
        moodCardScrollView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }

        let containerView = UIView()
        moodCardScrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        circleProgressBar.trackColor = .circleProgressBarDark
        circleProgressBar.progressColor = .circleProgressBarGray
        containerView.addSubview(circleProgressBar)

        circleProgressBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(circleProgressBar.snp.width)
        }

        containerView.addSubview(addMoodButton)
        addMoodButton.snp.makeConstraints { make in
            make.center.equalTo(circleProgressBar)
        }

        containerView.addSubview(cardsContainerView)
        cardsContainerView.snp.makeConstraints { make in
            make.top.equalTo(circleProgressBar.snp.bottom).offset(50)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        var previousCard: UIView?
        for (index, card) in moodCards.enumerated() {
            card.accessibilityIdentifier = "moodCard_\(index)"
            cardsContainerView.addSubview(card)
            card.snp.makeConstraints { make in
                if let previous = previousCard {
                    make.top.equalTo(previous.snp.bottom).offset(10)
                } else {
                    make.top.equalToSuperview().offset(10)
                }
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(158)
            }
            previousCard = card
        }

        if let lastCard = previousCard {
            lastCard.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(10)
            }
        }
    }

    private func setupAddMoodButtonAction() {
        addMoodButton.addTarget(self, action: #selector(addMoodButtonTapped), for: .touchUpInside)
    }

    private func updateEmptyState() {
        emptyStateLabel.isHidden = !moodCards.isEmpty
    }

    private func handleErrorState() {
        moodCardScrollView.isHidden = true
        emptyStateLabel.isHidden = true
        errorLabel.isHidden = false
    }

    // MARK: - Actions

    @objc private func addMoodButtonTapped() {
        let chooseMoodViewController = ChooseMoodViewController()
        let navController = UINavigationController(rootViewController: chooseMoodViewController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: false)
    }
}

#Preview {
    JournalViewController()
}
