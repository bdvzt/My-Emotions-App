//
//  AddNoteViewController.swift
//  LAB1
//
//  Created by Zayata Budaeva on 27.02.2025.
//

import UIKit
import SnapKit

final class AddNoteViewController: UIViewController {

    // MARK: - Dependencies
    private let viewModel: AddNoteViewModel
    private let activitiesViewModel: NoteAnswersViewModel
    private let peopleViewModel: NoteAnswersViewModel
    private let placesViewModel: NoteAnswersViewModel

    // MARK: - Private properties
    private let backArrow = BackArrow()
    private let moodCardView = MoodCardView()

    private let noteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Запись"
        label.font = UIFont(name: "Gwen-Trial-Regular", size: 24)
        return label
    }()

    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backArrow, noteLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()

    private lazy var activitiesView = NoteQuestionView(
        question: "Чем вы занимались?",
        viewModel: activitiesViewModel
    )
    private lazy var peopleView = NoteQuestionView(
        question: "С кем вы были?",
        viewModel: peopleViewModel
    )
    private lazy var placesView = NoteQuestionView(
        question: "Где вы были?",
        viewModel: placesViewModel
    )

    private let questionsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        return stack
    }()

    private let questionScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let saveButton = WhiteButton(title: "Сохранить")

    // MARK: - Inits

    init(viewModel: AddNoteViewModel,
         activitiesViewModel: NoteAnswersViewModel,
         peopleViewModel: NoteAnswersViewModel,
         placesViewModel: NoteAnswersViewModel
    ) {
        self.viewModel = viewModel
        self.activitiesViewModel = activitiesViewModel
        self.peopleViewModel = peopleViewModel
        self.placesViewModel = placesViewModel
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
        setupBackground()
        setupHeaderStackView()
        setupMoodCard()
        setupSaveButton()
        setupQuestionScrollView()
        setupBindings()
    }

    private func setupBackground() {
        view.backgroundColor = .black
    }

    private func setupHeaderStackView() {
        view.addSubview(headerStackView)
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        navigationItem.hidesBackButton = true
        backArrow.addTarget(self, action: #selector(backArrowTapped), for: .touchUpInside)
    }

    private func setupMoodCard() {
        view.addSubview(moodCardView)
        moodCardView.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(158)
        }
        configureMoodCard()
    }

    private func setupQuestionScrollView() {
        view.addSubview(questionScrollView)
        questionScrollView.addSubview(questionsStack)

        questionScrollView.snp.makeConstraints { make in
            make.top.equalTo(moodCardView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(saveButton.snp.top).offset(-20)
        }

        questionsStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        questionsStack.addArrangedSubview(activitiesView)
        questionsStack.addArrangedSubview(peopleView)
        questionsStack.addArrangedSubview(placesView)
    }

    private func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.centerX.equalToSuperview()
            make.width.equalTo(364)
            make.height.equalTo(56)
        }
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    // MARK: - Configure
    private func configureMoodCard() {
        let previewCard = MoodCard(
            id: UUID(),
            date: Date(),
            mood: viewModel.mood,
            activities: [],
            people: [],
            places: []
        )
        let viewModel = MoodCardViewModel(from: previewCard)
        moodCardView.configure(with: viewModel)
    }

    // MARK: - Actions
    private func setupBindings() {
        activitiesView.onSelectionChanged = { [weak self] selected in
            self?.viewModel.updateActivities(selected)
        }

        peopleView.onSelectionChanged = { [weak self] selected in
            self?.viewModel.updatePeople(selected)
        }

        placesView.onSelectionChanged = { [weak self] selected in
            self?.viewModel.updatePlaces(selected)
        }
    }

    @objc private func backArrowTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func saveButtonTapped() {
        viewModel.updateActivities(activitiesViewModel.selectedTitles)
        viewModel.updatePeople(peopleViewModel.selectedTitles)
        viewModel.updatePlaces(placesViewModel.selectedTitles)

        Task {
            await viewModel.saveNote()
        }
    }
}
