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

    private var addButton: NoteAnswerAddButton = {
        let button = NoteAnswerAddButton()
        return button
    }()

    var onAddTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(addButton) 
        addButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(40)
        }
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }

    @objc private func addTapped() {
        print("✅ Кнопка `+` нажата")
        onAddTapped?()
    }
}
