//
//  NoteQuestionView.swift
//  LAB1
//
//  Created by Zayata Budaeva on 28.02.2025.
//

import UIKit
import SnapKit

final class NoteQuestionView: UIView {

    // MARK: - Dependencies
    private var viewModel: NoteAnswersViewModel

    // MARK: - UI Elements
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 16)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private var collectionView: UICollectionView!
    private var collectionViewHeightConstraint: Constraint?

    // MARK: - Init
    init(question: String, viewModel: NoteAnswersViewModel) {

        self.viewModel = viewModel
        super.init(frame: .zero)
        questionLabel.text = question
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override var intrinsicContentSize: CGSize {
        let labelHeight = questionLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let collectionHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        return CGSize(width: UIView.noIntrinsicMetric, height: labelHeight + 8 + collectionHeight)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionViewHeight()
    }
}

private extension NoteQuestionView {
    func setup() {
        setupQuestionLabel()
        setupCollectionView()
    }

    func setupQuestionLabel() {
        addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(20)
        }
    }

    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NoteAnswerCell.self, forCellWithReuseIdentifier: NoteAnswerCell.reuseIdentifier)
        collectionView.register(NoteAnswerAddCell.self, forCellWithReuseIdentifier: NoteAnswerAddCell.reuseIdentifier)
        collectionView.allowsSelection = true

        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            collectionViewHeightConstraint = make.height.equalTo(10).constraint
        }
    }

    func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = .zero
        return layout
    }

    func updateCollectionViewHeight() {
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeightConstraint?.update(offset: height)
        invalidateIntrinsicContentSize()
    }

    func reloadAndUpdateLayout() {
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        updateCollectionViewHeight()
    }
}

extension NoteQuestionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.answers.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < viewModel.answers.count {
            let answer = viewModel.answers[indexPath.item]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NoteAnswerCell.reuseIdentifier,
                for: indexPath
            ) as? NoteAnswerCell else {
                return UICollectionViewCell()
            }

            let isSelected = viewModel.selectedAnswers.contains(answer.title)
            cell.configure(with: answer.title, selected: isSelected)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NoteAnswerAddCell.reuseIdentifier,
                for: indexPath
            ) as? NoteAnswerAddCell else {
                return UICollectionViewCell()
            }
            cell.onAddTapped = { [weak self] in self?.presentAddAnswerAlert() }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item < viewModel.answers.count {
            let text = viewModel.answers[indexPath.item].title
            let dummy = NoteAnswer(description: text)
            return dummy.intrinsicContentSize
        } else {
            return NoteAnswerAddButton().intrinsicContentSize
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.answers.count {
            presentAddAnswerAlert()
            return
        }

        let selected = viewModel.answers[indexPath.item].title
        print("😎😎😎")
        print(viewModel.answers[indexPath.item].title)
        viewModel.toggleAnswer(title: selected)
        collectionView.reloadData()
    }
}

private extension NoteQuestionView {
    func presentAddAnswerAlert() {
        guard let viewController = self.parentViewController else { return }

        let alert = UIAlertController(title: "Новый ответ", message: "Введите текст ответа", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Ваш ответ" }

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let self, let text = alert.textFields?.first?.text, !text.isEmpty else { return }

            let newAnswer = NoteAnswerItem(title: text, isDefault: false)

            self.viewModel.addAndSelect(text)
            self.reloadAndUpdateLayout()
        })

        viewController.present(alert, animated: true)
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let next = responder?.next {
            if let vc = next as? UIViewController { return vc }
            responder = next
        }
        return nil
    }
}

