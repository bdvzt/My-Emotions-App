//
//  CircleProgressBar.swift
//  LAB1
//
//  Created by Zayata Budaeva on 20.02.2025.
//

import UIKit

final class CircleProgressBar: UIView {

    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var trackLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var progressColor = UIColor.white {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }

    var trackColor = UIColor.white {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        createCircularPath()
    }

    fileprivate func createCircularPath() {
        let size = min(bounds.width, bounds.height)
        let radius = (size - 10) / 2
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)

        let circlePath = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius,
            startAngle: CGFloat(-0.5 * .pi),
            endAngle: CGFloat(1.5 * .pi),
            clockwise: true
        )

        trackLayer.path = circlePath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = radius * 0.15
        trackLayer.strokeEnd = 1.0
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)

        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = radius * 0.15
        progressLayer.strokeEnd = 0.9
        progressLayer.lineCap = .round
        layer.addSublayer(progressLayer)
    }

    func setProgressWithAnimation(duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "animateprogress")
    }
}
