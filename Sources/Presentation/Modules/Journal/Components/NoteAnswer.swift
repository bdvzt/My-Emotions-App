//
//  NoteAnswer.swift
//  LAB1
//
//  Created by Zayata Budaeva on 27.02.2025.
//

import UIKit
import SnapKit

final class NoteAnswer: UIButton
{
    // MARK: - Private properties

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private var chosen: Bool = false

    // MARK: - Inits

    init(description: String) {
        super.init(frame: .zero)
        setup(description: description)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(description: String) {
        setupView()
        setupLabel(description: description)
        setupConstraints()
        addTarget(self, action: #selector(changeColor), for: .touchUpInside)
    }

    private func setupView() {
        backgroundColor = .amountGray
        layer.cornerRadius = 18
    }

    private func setupLabel(description: String) {
        descriptionLabel.text = description
        addSubview(descriptionLabel)
    }

    private func setupConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.lessThanOrEqualToSuperview().inset(8)
        }
    }

    // MARK: - Actions
    func setSelected(_ selected: Bool) {
        chosen = selected
        backgroundColor = chosen ? .circleProgressBarGray : .amountGray
    }

    @objc private func changeColor() {
        chosen.toggle()
        backgroundColor = chosen ? .circleProgressBarGray : .amountGray
    }

    // MARK: - Dynamic width

    override var intrinsicContentSize: CGSize {
        let labelSize = descriptionLabel.intrinsicContentSize
        return CGSize(width: labelSize.width + 30,
                      height: labelSize.height + 16)
    }
}
