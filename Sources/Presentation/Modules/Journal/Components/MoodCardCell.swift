//
//  MoodCardCell.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 20.05.2025.
//

import UIKit

final class MoodCardCell: UITableViewCell {
    private let cardView = MoodCardView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { $0.edges.equalToSuperview().inset(8) }
        backgroundColor = .clear
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: MoodCardViewModel) {
        cardView.configure(with: viewModel)
    }

    func enableTap(target: Any?, action: Selector) {
        cardView.enableTap(target: target, action: action)
    }

    var cardId: UUID? {
        return cardView.cardId
    }
}
