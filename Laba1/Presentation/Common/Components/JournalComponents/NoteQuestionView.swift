//
//  NoteQuestionView.swift
//  LAB1
//
//  Created by Zayata Budaeva on 28.02.2025.
//

import UIKit
import SnapKit

final class NoteQuestionView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    // MARK: - Dependencies
    private var viewModel: NoteAnswersViewModel
    var onSelectionChanged: (([String]) -> Void)?

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

    // MARK: - Inits
    init(question: String, viewModel: NoteAnswersViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
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
            self.collectionViewHeightConstraint = make.height.equalTo(10).constraint
        }

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NoteAnswerCell.self, forCellWithReuseIdentifier: NoteAnswerCell.reuseIdentifier)
        collectionView.register(NoteAnswerAddCell.self, forCellWithReuseIdentifier: NoteAnswerAddCell.reuseIdentifier)
        collectionView.allowsSelection = true
    }

    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = .zero
        return layout
    }

    override var intrinsicContentSize: CGSize {
        let labelHeight = questionLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let collectionHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        let totalHeight = labelHeight + 8 + collectionHeight
        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }

    private func updateCollectionViewHeight() {
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeightConstraint?.update(offset: contentHeight)
        invalidateIntrinsicContentSize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionViewHeight()
    }

    private func reloadAndUpdateLayout() {
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        updateCollectionViewHeight()
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < viewModel.items.count {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NoteAnswerCell.reuseIdentifier,
                for: indexPath
            ) as? NoteAnswerCell else {
                return UICollectionViewCell()
            }
            let answerText = viewModel.items[indexPath.item].title
            cell.configure(with: answerText)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NoteAnswerAddCell.reuseIdentifier,
                for: indexPath
            ) as? NoteAnswerAddCell else {
                return UICollectionViewCell()
            }
            cell.onAddTapped = { [weak self] in
                self?.presentAddAnswerAlert()
            }
            return cell
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item < viewModel.items.count {
            let text = viewModel.items[indexPath.item].title
            let dummyButton = NoteAnswer(description: text)
            return dummyButton.intrinsicContentSize
        } else {
            let dummyAddButton = NoteAnswerAddButton()
            return dummyAddButton.intrinsicContentSize
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.items.count {
            presentAddAnswerAlert()
            return
        }

        let title = viewModel.items[indexPath.item].title
        viewModel.toggleSelection(for: title)
        onSelectionChanged?(viewModel.selectedTitles)
        collectionView.reloadData()
    }

    private func presentAddAnswerAlert() {
        guard let viewController = self.parentViewController else {
            return
        }
        let alert = UIAlertController(title: "Новый ответ", message: "Введите текст ответа", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Ваш ответ"
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Добавить", style: .default, handler: { [weak self] _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                self?.viewModel.add(text)
                self?.viewModel.toggleSelection(for: text)
                self?.onSelectionChanged?(self?.viewModel.selectedTitles ?? [])
                self?.collectionView.reloadData()
                self?.reloadAndUpdateLayout()
            }
        }))
        viewController.present(alert, animated: true, completion: nil)
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

final class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }

        var leftMargin: CGFloat = sectionInset.left
        var maxY: CGFloat = -1.0

        for layoutAttribute in attributes {
            if layoutAttribute.representedElementCategory == .cell {
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }

                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }

        return attributes
    }
}
