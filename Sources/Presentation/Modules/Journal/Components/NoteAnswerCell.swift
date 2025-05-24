//
//  NoteAnswerCell.swift
//  LAB1
//
//  Created by Zayata Budaeva on 27.02.2025.
//

import UIKit
import SnapKit

final class NoteAnswerCell: UICollectionViewCell {

    static let reuseIdentifier = "NoteAnswerCell"

    private var noteAnswer: NoteAnswer?

    var onTap: (() -> Void)?
    var onLongPress: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGestures()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        noteAnswer?.removeFromSuperview()
        onTap = nil
        onLongPress = nil
    }

    func configure(with answerText: String, selected: Bool) {
        noteAnswer?.removeFromSuperview()

        let answerButton = NoteAnswer(description: answerText)
        contentView.addSubview(answerButton)
        answerButton.snp.makeConstraints { $0.edges.equalToSuperview() }

        answerButton.setSelected(selected)
        answerButton.isUserInteractionEnabled = false
        noteAnswer = answerButton
    }

    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let long = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        long.minimumPressDuration = 0.6

        contentView.addGestureRecognizer(tap)
        contentView.addGestureRecognizer(long)
    }

    @objc private func handleTap() {
        onTap?()
    }

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            onLongPress?()
        }
    }
}
