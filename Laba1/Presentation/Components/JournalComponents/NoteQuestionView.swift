//
//  NoteQuestionView.swift
//  LAB1
//
//  Created by Zayata Budaeva on 27.02.2025.
//

import UIKit
import SnapKit

final class NoteQuestionView: UIView, UICollectionViewDelegateFlowLayout {

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
    private var answers: [String] = []

    // MARK: - Inits
    init(question: String, answers: [String]) {
        super.init(frame: .zero)
        self.answers = answers
        questionLabel.text = question
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setup() {
        setupQuestionLabel()
        setupCollectionView()
    }

    private func setupQuestionLabel() {
        addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(20)
        }
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NoteAnswerCell.self, forCellWithReuseIdentifier: NoteAnswerCell.reuseIdentifier)
        collectionView.register(NoteAnswerAddCell.self, forCellWithReuseIdentifier: NoteAnswerAddCell.reuseIdentifier)
        collectionView.allowsSelection = true
    }

    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        return layout
    }

    // MARK: - Dynamic height
    override var intrinsicContentSize: CGSize {
        let labelHeight = questionLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let collectionHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        let totalHeight = labelHeight + 8 + collectionHeight
        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item < answers.count {
            let text = answers[indexPath.item]
            let dummyButton = NoteAnswer(description: text)
            return dummyButton.intrinsicContentSize
        } else {
            let dummyAddButton = NoteAnswerAddButton()
            return dummyAddButton.intrinsicContentSize
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == answers.count {
            presentAddAnswerAlert()
        }
    }

    private func presentAddAnswerAlert() {
        guard let viewController = self.parentViewController else { return }
        let alert = UIAlertController(title: "Новый ответ", message: "Введите текст ответа", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Ваш ответ"
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Добавить", style: .default, handler: { [weak self] _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                self?.answers.append(text)
                self?.collectionView.reloadData()
            }
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension NoteQuestionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answers.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < answers.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteAnswerCell.reuseIdentifier, for: indexPath) as? NoteAnswerCell else {
                return UICollectionViewCell()
            }
            let answerText = answers[indexPath.item]
            cell.configure(with: answerText)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteAnswerAddCell.reuseIdentifier, for: indexPath) as? NoteAnswerAddCell else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let next = parentResponder?.next {
            parentResponder = next
            if let vc = parentResponder as? UIViewController {
                return vc
            }
        }
        return nil
    }
}

