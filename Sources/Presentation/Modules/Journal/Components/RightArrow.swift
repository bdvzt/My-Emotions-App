//
//  RightArrow.swift
//  LAB1
//
//  Created by Zayata Budaeva on 26.02.2025.
//

import UIKit
import SnapKit

final class RightArrow: UIButton {

    // MARK: - Inits

    init(chosen: Bool) {
        super.init(frame: .zero)
        setup(chosen: chosen)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    // MARK: - Setup

    private func setup(chosen: Bool) {
        clipsToBounds = true
        backgroundColor = chosen ? .white : .circleProgressBarGray
        tintColor = chosen ? .black : .white

        let arrowImage = UIImage(systemName: "arrow.right")?.withRenderingMode(.alwaysTemplate)
        setImage(arrowImage, for: .normal)
        imageView?.contentMode = .scaleAspectFit
    }
}
