//
//  NoteAnswerAddCell.swift
//  LAB1
//
//  Created by Zayata Budaeva on 28.02.2025.
//

import UIKit
import SnapKit

final class NoteAnswerAddCell: UICollectionViewCell {
    static let reuseIdentifier = "NoteAnswerAddCell"

    private var addButton: NoteAnswerAddButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addButton = NoteAnswerAddButton()
        contentView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
