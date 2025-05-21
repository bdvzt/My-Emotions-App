//
//  CircleProgressBar.swift
//  LAB1
//
//  Created by Zayata Budaeva on 20.02.2025.
//

import UIKit

final class CircleProgressBar: UIView {

    private let trackLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    private let maskLayer = CAShapeLayer()

    private var hasSetupLayers = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.addSublayer(trackLayer)
        layer.addSublayer(gradientLayer)
        gradientLayer.mask = maskLayer
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !hasSetupLayers {
            setupLayers()
            hasSetupLayers = true
        }
    }

    private func resetGradient() {
        gradientLayer.removeAllAnimations()
        gradientLayer.colors = nil
        gradientLayer.locations = nil
        gradientLayer.contents = nil
        maskLayer.strokeEnd = 0.0
    }

    private func setupLayers() {
        let radius = (min(bounds.width, bounds.height) - 28) / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: 1.5 * .pi,
            clockwise: true
        )

        trackLayer.path = circlePath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor(named: "CircleProgressBarDark")?.cgColor
        trackLayer.lineWidth = 28
        trackLayer.lineCap = .round
        trackLayer.frame = bounds
        layer.addSublayer(trackLayer)

        maskLayer.path = circlePath.cgPath
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.black.cgColor
        maskLayer.lineWidth = 28
        maskLayer.lineCap = .round
        maskLayer.strokeEnd = 0.0
        maskLayer.frame = bounds

        gradientLayer.frame = bounds
        gradientLayer.mask = maskLayer
        layer.addSublayer(gradientLayer)
    }

    func configure(withGradientPairs pairs: [GradientPair: Double], goalPercent: Double) {
        resetGradient()
        guard goalPercent > 0 else {
            startIdleAnimation()
            return
        }

        let progress = min(CGFloat(goalPercent), 1.0)
        maskLayer.strokeStart = 0
        maskLayer.strokeEnd = progress

        let total = pairs.values.reduce(0, +)
        guard total > 0 else {
            startIdleAnimation()
            return
        }

        let sortedPairs = pairs.sorted { $0.key.start.description < $1.key.start.description }

        let converted = sortedPairs.map { (start: $0.key.start, end: $0.key.end, percent: $0.value / total) }

        let image = drawCircularGradient(from: converted, progress: progress)
        gradientLayer.contents = image.cgImage
    }

    private func drawCircularGradient(from pairs: [(start: UIColor, end: UIColor, percent: Double)], progress: CGFloat) -> UIImage {
        let size = bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return UIImage() }

        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius = (min(size.width, size.height) - 28) / 2
        let lineWidth: CGFloat = 28
        let capRadius = lineWidth / 2

        var startAngle = -CGFloat.pi / 2
        let isSingleColor = pairs.count == 1

        for i in 0..<pairs.count {
            let pair = pairs[i]
            let sweepAngle = CGFloat(pair.percent) * 2 * .pi * progress
            let endAngle = startAngle + sweepAngle

            let colors = [pair.start.cgColor, pair.end.cgColor] as CFArray
            let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: [0.0, 1.0])!

            let overlap: CGFloat = .pi / 720
            let adjustedStart = startAngle - overlap
            let adjustedEnd = endAngle + overlap

            let path = UIBezierPath(
                arcCenter: center,
                radius: radius,
                startAngle: adjustedStart,
                endAngle: adjustedEnd,
                clockwise: true
            )

            ctx.saveGState()
            ctx.addPath(path.cgPath)
            ctx.setLineWidth(lineWidth + 0.5)
            ctx.setLineCap(.round)
            ctx.replacePathWithStrokedPath()
            ctx.clip()

            if isSingleColor {
                ctx.drawLinearGradient(
                    gradient,
                    start: center,
                    end: CGPoint(x: center.x + radius * cos(startAngle), y: center.y + radius * sin(startAngle)),
                    options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
                )
            } else {
                ctx.drawLinearGradient(
                    gradient,
                    start: CGPoint(x: center.x + radius * cos(adjustedStart), y: center.y + radius * sin(adjustedStart)),
                    end: CGPoint(x: center.x + radius * cos(adjustedEnd), y: center.y + radius * sin(adjustedEnd)),
                    options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
                )
            }

            ctx.restoreGState()

            if i == 0 {
                let capStartCenter = CGPoint(
                    x: center.x + radius * cos(startAngle),
                    y: center.y + radius * sin(startAngle)
                )
                ctx.setFillColor(pair.start.cgColor)
                ctx.fillEllipse(in: CGRect(
                    x: capStartCenter.x - capRadius,
                    y: capStartCenter.y - capRadius,
                    width: capRadius * 2,
                    height: capRadius * 2
                ))
            }

            if i == pairs.count - 1 {
                let capEndCenter = CGPoint(
                    x: center.x + radius * cos(endAngle),
                    y: center.y + radius * sin(endAngle)
                )
                ctx.setFillColor(pair.end.cgColor)
                ctx.fillEllipse(in: CGRect(
                    x: capEndCenter.x - capRadius,
                    y: capEndCenter.y - capRadius,
                    width: capRadius * 2,
                    height: capRadius * 2
                ))
            }

            startAngle = endAngle
        }

        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }

    func startIdleAnimation() {
        resetGradient()
        let progress: CGFloat = 0.6

        maskLayer.strokeStart = 0.0
        maskLayer.strokeEnd = progress

        let baseColor = UIColor(named: "CircleProgressBarGray") ?? .darkGray
        let fadeColor = UIColor(named: "CircleProgressBarDark") ?? .black

        gradientLayer.colors = [
            baseColor.withAlphaComponent(0.0001).cgColor,
            baseColor.withAlphaComponent(0.001).cgColor,
            baseColor.withAlphaComponent(0.01).cgColor,
            baseColor.withAlphaComponent(0.05).cgColor,
            baseColor.withAlphaComponent(0.1).cgColor,
            baseColor.withAlphaComponent(0.2).cgColor,
            baseColor.withAlphaComponent(0.3).cgColor,
            baseColor.withAlphaComponent(0.4).cgColor,
            baseColor.withAlphaComponent(0.5).cgColor,
            baseColor.cgColor
        ]

        gradientLayer.locations = [
            0.0,
            0.1,
            0.2,
            0.3,
            0.4,
            0.5,
            0.6,
            0.7,
            0.85,
            1.0
        ]

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        gradientLayer.removeAllAnimations()

        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * CGFloat.pi
        rotation.duration = 10
        rotation.repeatCount = .infinity
        gradientLayer.add(rotation, forKey: "rotation")
    }
}
