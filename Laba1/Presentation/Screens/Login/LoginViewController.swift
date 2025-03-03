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
        setup()
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
            make.top.equalToSuperview().inset(80)
            make.leading.equalToSuperview().inset(25)
            make.width.lessThanOrEqualToSuperview().inset(40)
        }
    }

    private func setupLoginButton() {
        view.addSubview(loginButton)

        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(45)
            make.width.equalTo(364)
            make.height.equalTo(80)
        }
    }

    private func setupGradient() {
        gradientLayer?.removeFromSuperlayer()

        let newGradientLayer = CAGradientLayer()
        newGradientLayer.masksToBounds = true
        newGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        newGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        newGradientLayer.locations = [0.25, 0.5, 0.75, 1.0]

        newGradientLayer.colors = [
            UIColor.loginGreen.cgColor,
            UIColor.loginRed.cgColor,
            UIColor.loginOrange.cgColor,
            UIColor.loginBlue.cgColor
        ]

        view.layer.insertSublayer(newGradientLayer, at: 0)
        gradientLayer = newGradientLayer
    }

    // MARK: - Actions

    @objc private func loginButtonTapped() {
        let tabController = TabController()
        tabController.modalPresentationStyle = .fullScreen
        present(tabController, animated: true, completion: nil)
    }
}

#Preview {
    LoginViewController()
}
