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
    
    private let tableView = UITableView()
    
    private let totalAmountCard = NotesAmountCard(description: "", amount: "")
    private let dayAmountCard = NotesAmountCard(description: "в день: ", amount: "")
    private let streakAmountCard = NotesAmountCard(description: "серия: ", amount: "")
    
    private let loadingContainer = UIView()
    private let emptyContainer = UIView()
    private let errorContainer = UIView()
    
    private var stats: NoteStatistics = NoteStatistics(
        totalCount: 0,
        dailyGoal: 1,
        streak: 0,
        circleStatistics: CircleStatistics(goalPercent: 0, bluePercent: 0, greenPercent: 0, redPercent: 0, orangePercent: 0)
    )
    
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
        makeDayAmountCardInteractive()
        Task {
            await journalListViewModel.fetchMoodCards()
            updateStatistics()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        Task {
            await journalListViewModel.fetchMoodCards()
            updateStatistics()
            self.animateProgress()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Setup
    private func setup() {
        view.backgroundColor = .black
        
        setupView()
        configureAccessibilityIdentifiers()
    }
    
    private func configureAccessibilityIdentifiers() {
        view.accessibilityIdentifier = "journalScreen"
        emptyStateLabel.accessibilityIdentifier = "emptyStateLabel"
        circleProgressBar.accessibilityIdentifier = "circleProgressBar"
        errorLabel.accessibilityIdentifier = "errorLabel"
    }
    
    private func setupView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        tableView.register(MoodCardCell.self, forCellReuseIdentifier: "MoodCardCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 158
        tableView.backgroundColor = .clear
        
        let header = buildHeaderView()
        tableView.tableHeaderView = header
    }
    
    private func buildHeaderView() -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let contentView = UIView()
        headerView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        loadingContainer.addSubview(loadingIndicator)
        emptyContainer.addSubview(emptyStateLabel)
        errorContainer.addSubview(errorLabel)
        
        loadingIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
        emptyStateLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        errorLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        
        let stack = UIStackView(arrangedSubviews: [
            wrapCenteredView(buildStatsStack()),
            buildQuestionSection(),
            wrapCenteredView(buildProgressSection()),
            loadingContainer,
            emptyContainer,
            errorContainer
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        headerView.layoutIfNeeded()
        let targetSize = CGSize(width: UIScreen.main.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let height = contentView.systemLayoutSizeFitting(targetSize).height
        headerView.frame = CGRect(x: 0, y: 0, width: targetSize.width, height: height)
        
        return headerView
    }
    
    private func wrapCenteredView(_ view: UIView) -> UIView {
        let container = UIView()
        container.addSubview(view)
        view.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        return container
    }
    
    private func buildStatsStack() -> UIStackView {
        notesAmountStack.axis = .horizontal
        notesAmountStack.spacing = 8
        notesAmountStack.alignment = .center
        notesAmountStack.distribution = .equalSpacing
        
        notesAmountStack.setContentHuggingPriority(.required, for: .horizontal)
        notesAmountStack.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        notesAmountStack.addArrangedSubview(totalAmountCard)
        notesAmountStack.addArrangedSubview(dayAmountCard)
        notesAmountStack.addArrangedSubview(streakAmountCard)
        
        return notesAmountStack
    }
    
    private func buildQuestionSection() -> UIView {
        let container = UIView()
        container.addSubview(questionLabel)
        
        questionLabel.textAlignment = .left
        
        questionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        return container
    }
    
    private func buildProgressSection() -> UIView {
        let container = UIView()
        container.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 32)
            make.height.equalTo(container.snp.width)
        }
        
        container.addSubview(circleProgressBar)
        circleProgressBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        circleProgressBar.isUserInteractionEnabled = false
        
        if addNoteStackView.arrangedSubviews.isEmpty {
            addNoteStackView.addArrangedSubview(addNoteButton)
            addNoteStackView.addArrangedSubview(addNoteLabel)
        }
        
        container.addSubview(addNoteStackView)
        addNoteStackView.snp.makeConstraints { $0.center.equalToSuperview() }
        
        addNoteButton.snp.makeConstraints { make in
            make.width.height.equalTo(64)
        }
        
        addNoteButton.addTarget(self, action: #selector(addMoodButtonTapped), for: .touchUpInside)
        
        return container
    }
    
    // MARK: - Actions
    private func animateProgress() {
        let circleStats = stats.circleStatistics

        let rawPairs: [GradientPair: Double] = [
            moodColorGradients[.moodBlue]!: circleStats.bluePercent,
            moodColorGradients[.moodRed]!: circleStats.redPercent,
            moodColorGradients[.moodGreen]!: circleStats.greenPercent,
            moodColorGradients[.moodOrange]!: circleStats.orangePercent
        ]

        let nonZeroPairs = rawPairs.filter { $0.value > 0 }

        if circleStats.goalPercent > 0, !nonZeroPairs.isEmpty {
            circleProgressBar.configure(
                withGradientPairs: nonZeroPairs,
                goalPercent: circleStats.goalPercent
            )
        } else {
            circleProgressBar.startIdleAnimation()
        }
    }
    
    @objc private func addMoodButtonTapped() {
        journalListViewModel.didTapAddMood()
    }
    
    @objc private func didTapCard(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? MoodCardView,
              let cardId = view.cardId else { return }
        
        journalListViewModel.didTapCard(with: cardId)
    }
    
    @objc private func didTapDayAmountCard() {
        let pickerVC = GoalPicker(
            initialValue: journalListViewModel.getNoteStatistics().dailyGoal,
            onValueSelected: { [weak self] newGoal in
                self?.journalListViewModel.updateDailyGoal(newGoal)
                self?.updateStatistics()
                self?.animateProgress()
            }
        )
        present(pickerVC, animated: true)
    }
    
    // MARK: - State
    private func showLoading() {
        loadingIndicator.startAnimating()
        loadingContainer.isHidden = false
        emptyContainer.isHidden = true
        errorContainer.isHidden = true
    }
    
    private func showEmpty() {
        loadingIndicator.stopAnimating()
        loadingContainer.isHidden = true
        emptyContainer.isHidden = false
        errorContainer.isHidden = true
    }
    
    private func showError() {
        loadingIndicator.stopAnimating()
        loadingContainer.isHidden = true
        emptyContainer.isHidden = true
        errorContainer.isHidden = false
    }
    
    private func showLoaded(cards: [MoodCardViewModel]) {
        loadingIndicator.stopAnimating()
        loadingContainer.isHidden = true
        emptyContainer.isHidden = true
        errorContainer.isHidden = true
        tableView.reloadData()
    }
    
    private func makeDayAmountCardInteractive() {
        dayAmountCard.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDayAmountCard))
        dayAmountCard.addGestureRecognizer(tap)
    }
    
    private func updateStatistics() {
        stats = journalListViewModel.getNoteStatistics()
        
        totalAmountCard.updateAmount(Plural.form(stats.totalCount, ("запись", "записи", "записей")))
        dayAmountCard.updateAmount(Plural.form(stats.dailyGoal, ("запись", "записи", "записей")))
        streakAmountCard.updateAmount(Plural.form(stats.streak, ("день", "дня", "дней")))
    }
}

extension JournalListViewController: JournalListStateDelegate {
    func didChangeState(state: JournalListViewModel.State) {
        switch state {
        case .loading:
            showLoading()
        case .loaded(let cards):
            showLoaded(cards: cards)
            tableView.reloadData()
        case .empty:
            showEmpty()
        case .error:
            showError()
        }
    }
}

extension JournalListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Card count:", journalListViewModel.moodCards.count)
        return journalListViewModel.moodCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoodCardCell", for: indexPath) as? MoodCardCell else {
            return UITableViewCell()
        }
        let viewModel = journalListViewModel.moodCards[indexPath.row]
        cell.configure(with: viewModel)
        cell.enableTap(target: self, action: #selector(didTapCard(_:)))
        return cell
    }
}

extension JournalListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completion in
            guard let self = self else { return }
            let id = self.journalListViewModel.moodCards[indexPath.row].id
            Task {
                await self.journalListViewModel.deleteCard(with: id)

                await self.journalListViewModel.fetchMoodCards()

                DispatchQueue.main.async {
                    self.updateStatistics()
                    self.animateProgress()
                    self.tableView.reloadData()
                    completion(true)
                }
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 158
    }
}

