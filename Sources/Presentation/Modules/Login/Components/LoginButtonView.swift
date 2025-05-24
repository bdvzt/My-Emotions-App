//
//  LoginButtonView.swift
//  LAB1
//
//  Created by Zayata Budaeva on 19.02.2025.
//

import UIKit
import SnapKit

final class LoginButtonView: UIButton {

    // MARK: - UI Elements

    private let appleIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .appleIcon
        return imageView
    }()

    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.text = "Войти через Apple ID"
        label.textColor = .black
        label.font = UIFont(name: "VelaSans-Regular", size: 16)
        return label
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .white
        layer.cornerRadius = 40
        clipsToBounds = true

        addSubview(stackView)

        stackView.isUserInteractionEnabled = false
        appleIcon.isUserInteractionEnabled = false
        buttonLabel.isUserInteractionEnabled = false

        stackView.addArrangedSubview(appleIcon)
        stackView.addArrangedSubview(buttonLabel)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }

        appleIcon.snp.makeConstraints { make in
            make.width.equalTo(42)
            make.height.equalTo(48)
        }
    }
}
