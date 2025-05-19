//
//  AvatarWithName.swift
//  LAB1
//
//  Created by Zayata Budaeva on 24.02.2025.
//

import UIKit
import SnapKit

final class AvatarWithName: UIView
{
    // MARK: - Private properties

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 24)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 48
        return imageView
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()

    // MARK: - Init

    init(avatarImage: UIImage, name: String) {
        super.init(frame: .zero)
        setup(avatarImage: avatarImage, name: name)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(avatarImage: UIImage, name: String) {
        nameLabel.text = name
        avatarImageView.image = avatarImage

        setupStackView()
        setupConstraints()
    }

    private func setupStackView() {
        addSubview(stackView)
        stackView.addArrangedSubview(avatarImageView)
        stackView.addArrangedSubview(nameLabel)
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(96)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
