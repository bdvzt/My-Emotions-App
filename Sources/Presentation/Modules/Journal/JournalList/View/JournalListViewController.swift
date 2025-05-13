//
//  JournalListViewController.swift
//  LAB1
//
//  Created by Zayata Budaeva on 20.02.2025.
//

import UIKit
import SnapKit

class JournalListViewController: UIViewController {

    // MARK: - Dependencies
    private let journalListViewModel: JournalListViewModel

    // MARK: - UI Components

    private let contentView = UIView()
    private let scrollView = UIScrollView()
    private let notesAmountStack = UIStackView()
    private let progressContainer = UIView()
    private let circleProgressBar = CircleProgressBar()

    // MARK: - PLaceholders

    private let loadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.hidesWhenStopped = true
        return spinner
    }()

    private var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет записей о настроении"
        label.textColor = .white
        label.textAlignment = .center
        label.font =  UIFont(name: "VelaSans-Regular", size: 20)
        label.isHidden = true
        return label
    }()

    private var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Ошибка загрузки данных"
        label.textColor = .white
        label.textAlignment = .center
        label.font =  UIFont(name: "VelaSans-Regular", size: 20)
        label.isHidden = true
        return label
    }()

    // MARK: - Components
    private let cardsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        return stack
    }()

    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gwen-Trial-Regular", size: 36)
        label.textColor = .white
        label.text = "Что вы сейчас чувствуете?"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let addNoteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 16)
        label.textColor = .white
        label.text = "Добавить запись"
        label.textAlignment = .center
        return label
    }()

    private let addNoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setImage(UIImage(resource: .plus), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 32
        button.clipsToBounds = true
        return button
    }()

    private let addNoteStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init

    init(journalListViewModel: JournalListViewModel) {
        self.journalListViewModel = journalListViewModel
        super.init(nibName: nil, bundle: nil)
        journalListViewModel.stateDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        Task {
            await journalListViewModel.fetchMoodCards()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        Task {
            await journalListViewModel.fetchMoodCards()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.perform(#selector(animateProgress), with: nil, afterDelay: 2.0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Setup
    private func setup() {
        view.backgroundColor = .black

        setupScrollView()
        setupNotesStatistics()
        setupQuestionLabel()
        setupCircleProgressBar()
        setupCardsStack()
        configureAccessibilityIdentifiers()
        setupLoadingState()
        setupEmptyState()
        setupErrorState()
    }

    private func configureAccessibilityIdentifiers() {
        view.accessibilityIdentifier = "journalScreen"
        emptyStateLabel.accessibilityIdentifier = "emptyStateLabel"
        circleProgressBar.accessibilityIdentifier = "circleProgressBar"
        errorLabel.accessibilityIdentifier = "errorLabel"
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.addSubview(contentView)

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
    }

    private func setupCardsStack() {
        contentView.addSubview(cardsStackView)
        cardsStackView.snp.makeConstraints { make in
            make.top.equalTo(progressContainer.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(30)
        }
    }

    private func setupNotesStatistics() {
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

        contentView.addSubview(notesAmountStack)

        notesAmountStack.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(5)
            make.centerX.equalToSuperview()
        }
    }

    private func setupQuestionLabel() {
        contentView.addSubview(questionLabel)

        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(notesAmountStack.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
        }
    }

    private func setupCircleProgressBar() {
        contentView.addSubview(progressContainer)
        progressContainer.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(300)
        }

        progressContainer.addSubview(circleProgressBar)
        circleProgressBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        circleProgressBar.isUserInteractionEnabled = false

        addNoteStackView.addArrangedSubview(addNoteButton)
        addNoteStackView.addArrangedSubview(addNoteLabel)

        progressContainer.addSubview(addNoteStackView)
        addNoteStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        addNoteButton.snp.makeConstraints { make in
            make.width.height.equalTo(64)
        }

        addNoteButton.addTarget(self, action: #selector(addMoodButtonTapped), for: .touchUpInside)
    }

    private func setupLoadingState() {
        contentView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.top.equalTo(circleProgressBar.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
        }
    }

    private func setupEmptyState() {
        contentView.addSubview(emptyStateLabel)
        emptyStateLabel.snp.makeConstraints { make in
            make.top.equalTo(circleProgressBar.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
    }

    private func setupErrorState() {
        contentView.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(circleProgressBar.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Actions
    @objc private func animateProgress() {
        if !circleProgressBar.isHidden {
            circleProgressBar.setProgressWithAnimation(duration: 1.0, value: 0.7)
        }
    }

    @objc private func addMoodButtonTapped() {
        journalListViewModel.didTapAddMood()
    }

    // MARK: - State
    private func showLoading() {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        emptyStateLabel.isHidden = true
        errorLabel.isHidden = true
        cardsStackView.isHidden = true
    }

    private func showLoaded(cards: [MoodCardViewModel]) {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        emptyStateLabel.isHidden = true
        errorLabel.isHidden = true
        cardsStackView.isHidden = false
        renderMoodCards(cards)
    }

    private func showEmpty() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        cardsStackView.isHidden = true
        errorLabel.isHidden = true
        emptyStateLabel.isHidden = false
    }

    private func showError() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        cardsStackView.isHidden = true
        emptyStateLabel.isHidden = true
        errorLabel.isHidden = false
    }

    // MARK: - Show Mood Cards
    private func renderMoodCards(_ cards: [MoodCardViewModel]) {
        cardsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for cardViewModel in cards {
            let cardView = MoodCardView()
            cardView.configure(with: cardViewModel)
            cardsStackView.addArrangedSubview(cardView)

            cardView.snp.makeConstraints { make in
                make.height.equalTo(158)
            }
        }
    }
}

extension JournalListViewController: JournalListStateDelegate {
    func didChangeState(state: JournalListViewModel.State) {
        switch state {
        case .loading:
            showLoading()
        case .loaded(let cards):
            showLoaded(cards: cards)
        case .empty:
            showEmpty()
        case .error:
            showError()
        }
    }
}
