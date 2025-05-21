//
//  NoteAnswerCell.swift
//  LAB1
//
//  Created by Zayata Budaeva on 27.02.2025.
//

import UIKit
import SnapKit

final class NoteAnswerCell: UICollectionViewCell {

    // MARK: - Private properties

    static let reuseIdentifier = "NoteAnswerCell"
    private var noteAnswer: NoteAnswer?

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    func configure(with answerText: String, selected: Bool) {
        noteAnswer?.removeFromSuperview()

        let answerButton = NoteAnswer(description: answerText)
        contentView.addSubview(answerButton)
        answerButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        answerButton.setSelected(selected)
        answerButton.isUserInteractionEnabled = false
        noteAnswer = answerButton
    }
}

