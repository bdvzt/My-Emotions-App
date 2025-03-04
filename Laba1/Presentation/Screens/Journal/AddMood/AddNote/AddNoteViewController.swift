//
//  AddNoteViewController.swift
//  LAB1
//
//  Created by Zayata Budaeva on 27.02.2025.
//

import UIKit
import SnapKit

final class AddNoteViewController: UIViewController {

    // MARK: - Private properties

    private var moodCardView: MoodCardView
    private let backArrow = BackArrow()

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

    private let whatQuestionView = NoteQuestionView(
        question: "Чем вы занимались?",
        answers: ["Приём пищи", "Встреча с друзьями", "Тренировка", "Хобби", "Отдых", "Поездка"]
    )

    private let withWhomQuestionView = NoteQuestionView(
        question: "С кем вы были?",
        answers: ["Один", "Друзья", "Семья", "Коллеги", "Партнёр", "Питомцы"]
    )

    private let whereQuestionView = NoteQuestionView(
        question: "Где вы были?",
        answers: ["Дом", "Работа", "Школа", "Транспорт", "Улица"]
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

    init(color: UIColor, mood: String) {
        self.moodCardView = MoodCardView(
            color: color,
            image: .shell,
            dateText: "сегодня, 14:36",
            moodText: mood
        )
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

    // MARK: - Setup

    private func setup() {
        setupBackground()
        setupHeaderStackView()
        setupMoodCard()
        setupSaveButton()
        setupQuestionScrollView()
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
        backArrow.addTarget(self, action: #selector(backArrowTapped), for: .touchUpInside)
    }

    private func setupMoodCard() {
        view.addSubview(moodCardView)
        moodCardView.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(158)
        }
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

        questionsStack.addArrangedSubview(whatQuestionView)
        questionsStack.addArrangedSubview(withWhomQuestionView)
        questionsStack.addArrangedSubview(whereQuestionView)
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

    // MARK: - Actions

    @objc private func backArrowTapped() {
        dismiss(animated: false, completion: nil)
    }

    @objc private func saveButtonTapped() {
        let tabController = TabController()
        tabController.modalPresentationStyle = .fullScreen
        present(tabController, animated: false, completion: nil)
    }
}
