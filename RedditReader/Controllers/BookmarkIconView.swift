//
//  BookmarkIconView.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/28/24.
//

import UIKit

class BookmarkIconView: UIView {

    let edge: CGFloat = 50
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: edge * 2 / 3, height: edge)
    }
    
    init() {
        let size = CGSize(width: edge * 2 / 3, height: edge)
        super.init(frame: CGRect(origin: .zero, size: size))
        self.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawBookmark(in: rect)
    }
    
    private func drawBookmark(in rect: CGRect) {
        
        let cornerRadius = edge / 20
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.midX - edge / 3 + cornerRadius, y: rect.midY - edge / 2))
        path.addLine(to: CGPoint(x: rect.midX + edge / 3 - cornerRadius, y: rect.midY - edge / 2))
        path.addArc(withCenter: CGPoint(x: rect.midX + edge / 3 - cornerRadius, y: rect.midY - edge / 2 + cornerRadius),
                        radius: cornerRadius,
                        startAngle: -CGFloat.pi / 2,
                        endAngle: 0,
                        clockwise: true)
        path.addLine(to: CGPoint(x: rect.midX + edge / 3, y: rect.midY + edge / 3))
        path.addQuadCurve(to: CGPoint(x: rect.midX + 5 * edge / 24, y: rect.midY + 9 * edge / 24), controlPoint: CGPoint(x: rect.midX + edge / 3, y: rect.midY + edge / 2))
        
        
        path.addLine(to: CGPoint(x: rect.midX + edge / 24, y: rect.midY + 5 * edge / 24))
        
        path.addQuadCurve(to: CGPoint(x: rect.midX - edge / 24, y: rect.midY + 5*edge / 24), controlPoint: CGPoint(x: rect.midX, y: rect.midY + edge / 6))
        
        path.addLine(to: CGPoint(x: rect.midX - 5 * edge / 24, y: rect.midY + 9 * edge / 24))
        
        path.addQuadCurve(to: CGPoint(x: rect.midX - edge / 3, y: rect.midY + edge / 3), controlPoint: CGPoint(x: rect.midX - edge / 3, y: rect.midY + edge / 2))
        
        
        path.addArc(withCenter: CGPoint(x: rect.midX - edge / 3 + cornerRadius, y: rect.midY - edge / 2 + cornerRadius),
                        radius: cornerRadius,
                        startAngle: -CGFloat.pi,
                        endAngle: -CGFloat.pi / 2,
                        clockwise: true)

        path.close()

        // 1. Create gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = rect
//        let orangered = UIColor(red: 255/255, green: 67/255, blue: 0/255, alpha: 1)
        gradientLayer.colors = [UIColor.cyan.cgColor, UIColor.systemPurple.cgColor, UIColor.red.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.locations = [0, 0.55, 1]
        
        // 2. Create shape layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 1

        // 3. Add mask to gradient layer
        gradientLayer.mask = shapeLayer

        // 4. Add gradient layer to the view's layer
        layer.addSublayer(gradientLayer)
    }
}
