//
//  AddReminderButton.swift
//  LAB1
//
//  Created by Zayata Budaeva on 24.02.2025.
//

import UIKit
import SnapKit

final class WhiteButton: UIButton
{

    // MARK: - Inits

    init(title: String) {
        super.init(frame: .zero)
        setup(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        backgroundColor = .white
        titleLabel?.font = UIFont(name: "VelaSans-Regular", size: 16)
        layer.cornerRadius = 30
        layer.masksToBounds = true
    }
}
