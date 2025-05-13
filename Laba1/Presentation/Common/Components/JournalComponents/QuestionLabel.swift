//
//  QuestionLabel.swift
//  LAB1
//
//  Created by Zayata Budaeva on 20.02.2025.
//

import UIKit
import SnapKit

final class QuestionLabel: UIView
{
    // MARK: - Private properties

    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gwen-Trial-Regular", size: 36)
        label.textColor = .white
        label.text = "Что вы сейчас чувствуете?"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
