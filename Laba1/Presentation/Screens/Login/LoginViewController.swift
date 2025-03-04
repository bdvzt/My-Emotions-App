//
//  LoginViewController.swift
//  LAB1
//
//  Created by Zayata Budaeva on 19.02.2025.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    // MARK: - Private properties

    private let loginButton = LoginButtonView()
    private let welcomeLabel = UILabel()
    private var gradientLayer: CAGradientLayer?

    private let gradientColors: [[CGColor]] = [
        [UIColor.loginRed.cgColor, UIColor.loginBlue.cgColor, UIColor.loginGreen.cgColor, UIColor.loginOrange.cgColor],
        [UIColor.loginGreen.cgColor, UIColor.loginOrange.cgColor, UIColor.loginRed.cgColor, UIColor.loginBlue.cgColor],
        [UIColor.loginOrange.cgColor, UIColor.loginRed.cgColor, UIColor.loginBlue.cgColor, UIColor.loginGreen.cgColor],
        [UIColor.loginBlue.cgColor, UIColor.loginGreen.cgColor, UIColor.loginOrange.cgColor, UIColor.loginRed.cgColor],
        [UIColor.loginRed.cgColor, UIColor.loginBlue.cgColor, UIColor.loginGreen.cgColor, UIColor.loginOrange.cgColor]
    ]

    // MARK: - Inits

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.accessibilityIdentifier = "loginButton"
        welcomeLabel.accessibilityIdentifier = "welcomeLabel"
        view.accessibilityIdentifier = "loginScreen"

        setup()
        startGradientAnimation()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }

    // MARK: - Setup

    private func setup() {
        setupLoginButton()
        setupWelcomeLabel()
        setupGradient()
    }

    private func setupWelcomeLabel() {
        view.addSubview(welcomeLabel)
        welcomeLabel.text = "Добро пожаловать"
        welcomeLabel.textColor = .black
        welcomeLabel.font = UIFont(name: "Gwen-Trial-Bold", size: 48)
        welcomeLabel.numberOfLines = 0
        welcomeLabel.textAlignment = .left

        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
            make.leading.equalToSuperview().inset(25)
            make.width.lessThanOrEqualToSuperview().inset(40)
        }
    }

    private func setupLoginButton() {
        view.addSubview(loginButton)

        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(40)
            make.trailing.leading.equalToSuperview().inset(25)
            make.height.equalTo(80)
        }
    }

    private func setupGradient() {
        gradientLayer?.removeFromSuperlayer()

        let newGradientLayer = CAGradientLayer()
        newGradientLayer.frame = view.bounds
        newGradientLayer.colors = gradientColors.first
        newGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        newGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        newGradientLayer.locations = [0.0, 0.5, 1.0]

        view.layer.insertSublayer(newGradientLayer, at: 0)
        gradientLayer = newGradientLayer
    }

    // MARK: - Gradient Animation

    private func startGradientAnimation() {
        guard let gradientLayer = gradientLayer else { return }

        let animationDuration: CFTimeInterval = 25.0

        let colorAnimation = CAKeyframeAnimation(keyPath: "colors")
        colorAnimation.values = gradientColors
        colorAnimation.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        colorAnimation.duration = animationDuration
        colorAnimation.repeatCount = .infinity
        colorAnimation.timingFunction = CAMediaTimingFunction(name: .linear)

        gradientLayer.add(colorAnimation, forKey: "colorCycle")
    }

    // MARK: - Actions

    @objc private func loginButtonTapped() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let tabController = TabController()
            window.rootViewController = tabController
        }
    }
}

#Preview {
    LoginViewController()
}

