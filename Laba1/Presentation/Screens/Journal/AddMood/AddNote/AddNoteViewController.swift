//
//  AddNoteViewController.swift
//  LAB1
//
//  Created by Zayata Budaeva on 27.02.2025.
//

import UIKit
import SnapKit

final class AddNoteViewController: UIViewController {

    // MARK: - Public properties

    var saveMoodCard: ((UIColor, String) -> Void)?

    // MARK: - Private properties
    private var chosenColor: UIColor?
    private var chosenMood: String?
    private var moodCardView: MoodCardView?
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

    private let whatQuestionView: NoteQuestionView = {
        let answers = [
            "Приём пищи",
            "Встреча с друзьями",
            "Тренировка",
            "Хобби",
            "Отдых",
            "Поездка"
        ]
        return NoteQuestionView(question: "Чем вы занимались?", answers: answers)
    }()

    private let withWhomQuestionView: NoteQuestionView = {
        let answers = [
            "Один",
            "Друзья",
            "Семья",
            "Коллеги",
            "Партнёр",
            "Питомцы"
        ]
        return NoteQuestionView(question: "С кем вы были?", answers: answers)
    }()

    private let whereQuestionView: NoteQuestionView = {
        let answers = [
            "Дом",
            "Работа",
            "Школа",
            "Транспорт",
            "Улица"
        ]
        return NoteQuestionView(question: "Где вы были?", answers: answers)
    }()

    private let saveButton: WhiteButton = {
        let button = WhiteButton(title: "Сохранить")
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupMoodIfNeeded()
    }

    // MARK: - Public methods

    func setupMoodCard(color: UIColor, mood: String) {
        self.chosenColor = color
        self.chosenMood = mood
    }

    // MARK: - Private logic

    private func setupMoodIfNeeded() {
        guard let color = chosenColor, let mood = chosenMood else { return }

        let newMoodCardView = MoodCardView(
            color: color,
            image: .shell,
            dateText: "сегодня, 14:36",
            moodText: mood
        )
        self.moodCardView = newMoodCardView

        view.addSubview(newMoodCardView)
        newMoodCardView.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(30)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
            make.height.equalTo(158)
        }
    }

    // MARK: - Setup

    private func setup() {
        setupBackground()
        setupHeaderStackView()
        setupQuestionViews()
        setupSaveButton()
    }

    private func setupBackground() {
        view.backgroundColor = .black
    }

    private func setupHeaderStackView() {
        view.addSubview(headerStackView)
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
        }
    }

    private func setupQuestionViews() {
        view.addSubview(whatQuestionView)
        view.addSubview(withWhomQuestionView)
        view.addSubview(whereQuestionView)

        whatQuestionView.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(30)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
        }

        withWhomQuestionView.snp.makeConstraints { make in
            make.top.equalTo(whatQuestionView.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
        }

        whereQuestionView.snp.makeConstraints { make in
            make.top.equalTo(withWhomQuestionView.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
        }
    }

    private func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.centerX.equalTo(view)
            make.width.equalTo(364)
            make.height.equalTo(56)
        }
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func saveButtonTapped() {
        guard let color = chosenColor, let mood = chosenMood else {
            dismiss(animated: true)
            return
        }
        saveMoodCard?(color, mood) 
        dismiss(animated: true)
    }
}

#if DEBUG
import SwiftUI
struct AddNoteViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AddNoteViewController {
        let vc = AddNoteViewController()
        vc.setupMoodCard(color: .loginBlue, mood: "Выгорание")
        return vc
    }
    func updateUIViewController(_ uiViewController: AddNoteViewController, context: Context) {}
}

struct AddNoteViewController_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteViewControllerPreview()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
