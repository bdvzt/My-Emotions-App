//
//  MoodCardView.swift
//  LAB1
//
//  Created by Zayata Budaeva on 20.02.2025.
//

import UIKit
import SnapKit

final class MoodCardView: UIView {
    
    // MARK: - UI Elements
    
    private var gradientLayer: CAGradientLayer?
    var cardId: UUID?
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 14)
        label.textColor = .white
        return label
    }()
    
    private let iFeelLabel: UILabel = {
        let label = UILabel()
        label.text = "Я чувствую"
        label.font = UIFont(name: "VelaSans-Regular", size: 20)
        label.textColor = .white
        return label
    }()
    
    private let moodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gwen-Trial-Bold", size: 28)
        return label
    }()
    
    private let moodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private let moodStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 3
        stack.alignment = .leading
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
        layer.cornerRadius = 16
        clipsToBounds = true
    }

    // MARK: - Public
    
    func configure(with viewModel: MoodCardViewModel) {
        self.cardId = viewModel.id
        dateLabel.text = viewModel.dateString
        moodLabel.text = viewModel.moodTitle.lowercased()
        moodLabel.textColor = viewModel.moodColor
        moodImageView.image = viewModel.moodIcon
        applyGradient(for: viewModel.moodColor)
    }
    
    // MARK: - Setup
    
    private func setup() {
        addSubview(dateLabel)
        
        moodStackView.addArrangedSubview(iFeelLabel)
        moodStackView.addArrangedSubview(moodLabel)
        
        bottomStackView.addArrangedSubview(moodStackView)
        bottomStackView.addArrangedSubview(moodImageView)
        addSubview(bottomStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        moodImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
    }

    func enableTap(target: Any?, action: Selector) {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tap)
    }
}

// MARK: - Gradient
private extension MoodCardView {
    
    func applyGradient(for color: UIColor) {
        gradientLayer?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.masksToBounds = true
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.locations = [0.0, 1.0]
        gradient.colors = gradientColors(for: color)
        
        layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    func gradientColors(for color: UIColor) -> [CGColor] {
        let black = UIColor.feelingGradientBlack.cgColor
        switch color {
        case .moodOrange:
            return [black, UIColor.feelingGradientOrange.cgColor]
        case .moodRed:
            return [black, UIColor.feelingGradientRed.cgColor]
        case .moodBlue:
            return [black, UIColor.feelingGradientBlue.cgColor]
        case .moodGreen:
            return [black, UIColor.feelingGradientGreen.cgColor]
        default:
            return [black, UIColor.feelingGradientOrange.cgColor]
        }
    }
}
