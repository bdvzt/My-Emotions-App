//
//  NoteAnswerAddButton.swift
//  LAB1
//
//  Created by Zayata Budaeva on 28.02.2025.
//

import UIKit
import SnapKit

final class NoteAnswerAddButton: UIButton {
    private let plusImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "plus")
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .amountGray  
        layer.cornerRadius = 18
        clipsToBounds = true
        addSubview(plusImageView)
        plusImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(16)
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 60, height: 40)
    }
}
