//
//  BackArrow.swift
//  LAB1
//
//  Created by Zayata Budaeva on 26.02.2025.
//

import UIKit
import SnapKit

final class BackArrow: UIButton {

    // MARK: - Inits

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 40)
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .feelingGradientBlack
        layer.cornerRadius = 20
        clipsToBounds = true

        let arrowImage = UIImage(systemName: "arrow.backward")
        setImage(arrowImage, for: .normal)
        tintColor = .white

        imageView?.contentMode = .scaleAspectFit
        addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }

    @objc private func backButtonTapped() {
        if let viewController = self.findViewController() {
            if let navigationController = viewController.navigationController {
                navigationController.popViewController(animated: false)
            } else {
                viewController.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}
