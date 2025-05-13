//
//  LoginViewController.swift
//  LAB1
//
//  Created by Zayata Budaeva on 19.02.2025.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    let loginViewModel: LoginViewModel


    // MARK: - Properties

    private let loginButton = LoginButtonView()
    private let welcomeLabel = UILabel()
    private var gradientLayer: CAGradientLayer?

    // MARK: - Inits

    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        configureAccessibilityIdentifiers()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        startGradientAnimation()
    }

    // MARK: - Setup

    private func setup() {
        setupLoginButton()
        setupWelcomeLabel()
        setupGradientLayer()
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

    private func setupGradientLayer() {
        gradientLayer?.removeFromSuperlayer()

        let newGradientLayer = CAGradientLayer()
        newGradientLayer.frame = view.bounds
        newGradientLayer.colors = Self.gradientColors.first
        newGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        newGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        newGradientLayer.locations = [0.0, 0.5, 1.0]

        view.layer.insertSublayer(newGradientLayer, at: 0)
        gradientLayer = newGradientLayer
    }

    private func configureAccessibilityIdentifiers() {
        view.accessibilityIdentifier = "loginScreen"
        welcomeLabel.accessibilityIdentifier = "welcomeLabel"
        loginButton.accessibilityIdentifier = "loginButton"
    }

    // MARK: - Gradient Animation

    private func startGradientAnimation() {
        guard let gradientLayer = gradientLayer else { return }

        let animationDuration: CFTimeInterval = 25.0

        let colorAnimation = CAKeyframeAnimation(keyPath: "colors")
        colorAnimation.values = Self.gradientColors
        colorAnimation.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        colorAnimation.duration = animationDuration
        colorAnimation.repeatCount = .infinity
        colorAnimation.timingFunction = CAMediaTimingFunction(name: .linear)

        gradientLayer.add(colorAnimation, forKey: "colorCycle")
    }

    @objc private func loginButtonTapped() {
        loginViewModel.didTapLoginButton()
    }
}

// MARK: - Gradient colors

private extension LoginViewController {
    static var gradientColors: [[CGColor]] {
        return [
            [UIColor.moodRed.cgColor, UIColor.moodBlue.cgColor, UIColor.moodGreen.cgColor, UIColor.moodOrange.cgColor],
            [UIColor.moodGreen.cgColor, UIColor.moodOrange.cgColor, UIColor.moodRed.cgColor, UIColor.moodBlue.cgColor],
            [UIColor.moodOrange.cgColor, UIColor.moodRed.cgColor, UIColor.moodBlue.cgColor, UIColor.moodGreen.cgColor],
            [UIColor.moodBlue.cgColor, UIColor.moodGreen.cgColor, UIColor.moodOrange.cgColor, UIColor.moodRed.cgColor],
            [UIColor.moodRed.cgColor, UIColor.moodBlue.cgColor, UIColor.moodGreen.cgColor, UIColor.moodOrange.cgColor]
        ]
    }
}
