//
//  Cloud.swift
//  vkontakteVS
//
//  Created by Home on 14.08.2021.
//

import UIKit

class Cloud: UIView {
    private let cloudLayer = CAShapeLayer()
    private let cloudePath = CloudPath.shape
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        frame = CGRect(x: 0, y: 0, width: 130, height: 80)
        
        let scale = CGSize(width: self.bounds.size.width / cloudePath.bounds.size.width, height: self.bounds.size.height / cloudePath.bounds.size.height)
        cloudePath.apply(CGAffineTransform(scaleX: scale.width, y: scale.height))
        cloudLayer.path = cloudePath.cgPath
        cloudLayer.lineWidth = 0.0
        cloudLayer.fillColor = UIColor.white.cgColor
        cloudLayer.strokeColor =  #colorLiteral(red: 0.262745098, green: 0.3529411765, blue: 0.3921568627, alpha: 1)
        cloudLayer.lineCap = .round
        //cloudLayer.strokeStart = 0.5
        //cloudLayer.strokeEnd = 1
        self.layer.addSublayer(cloudLayer)
    }
    
    func animationStart() {
        cloudLayer.lineWidth = 5.0
        let duration: CFTimeInterval = 5
        let startAnimationStroke = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeStart))
        startAnimationStroke.fromValue = 0
        startAnimationStroke.toValue = 1
        //startAnimationStroke.duration = 3
        startAnimationStroke.beginTime = 0.2

        let endAnimationStroke = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        endAnimationStroke.fromValue = 0
        endAnimationStroke.toValue = 1
        //endAnimationStroke.beginTime = 2
        //endAnimationStroke.duration = 10


        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [endAnimationStroke, startAnimationStroke]
        animationGroup.repeatCount = .infinity
        animationGroup.duration = duration

        cloudLayer.add(animationGroup, forKey: nil)
        
        //Test CAKeyframeAnimation animation
//        let circle = CAShapeLayer()
//        circle.backgroundColor = UIColor.red.cgColor
//        circle.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
//        circle.position = CGPoint(x: 40, y: 20)
//        circle.cornerRadius = 5
//        self.layer.addSublayer(circle)
//
//        let followPathAnimation = CAKeyframeAnimation(keyPath: "position")
//        followPathAnimation.path = cloudePath.cgPath
//        followPathAnimation.calculationMode = CAAnimationCalculationMode.cubicPaced
//        followPathAnimation.speed = 0.05
//        followPathAnimation.repeatCount = .infinity
//
//        circle.add(followPathAnimation, forKey: nil)
    }
    
    func animationStop() {
        cloudLayer.lineWidth = 0.0
        cloudLayer.removeAllAnimations()
    }
}

struct CloudPath {
    static var shape: UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 4649, y: 336.4))
    path.addCurve(to: CGPoint(x: 2800.5, y: 1827.7), controlPoint1: CGPoint(x: 3771.9, y: 336.4), controlPoint2: CGPoint(x: 3031, y: 966.8))
    path.addCurve(to: CGPoint(x: 2476.1, y: 1731.4), controlPoint1: CGPoint(x: 2704.5, y: 1766.6), controlPoint2: CGPoint(x: 2594.1, y: 1731.4))
    path.addCurve(to: CGPoint(x: 1814.9, y: 2476.6), controlPoint1: CGPoint(x: 2111.1, y: 1731.4), controlPoint2: CGPoint(x: 1814.9, y: 2065.2))
    path.addCurve(to: CGPoint(x: 1814.9, y: 2489), controlPoint1: CGPoint(x: 1814.9, y: 2480.8), controlPoint2: CGPoint(x: 1814.8, y: 2484.8))
    path.addCurve(to: CGPoint(x: 1472.2, y: 2449.4), controlPoint1: CGPoint(x: 1705.5, y: 2463.7), controlPoint2: CGPoint(x: 1590.9, y: 2449.4))
    path.addCurve(to: CGPoint(x: 161.5, y: 3567.7), controlPoint1: CGPoint(x: 748.7, y: 2449.4), controlPoint2: CGPoint(x: 161.5, y: 2950.6))
    path.addCurve(to: CGPoint(x: 1472.2, y: 4686), controlPoint1: CGPoint(x: 161.5, y: 4184.9), controlPoint2: CGPoint(x: 748.7, y: 4686))

path.addCurve(to: CGPoint(x: 2239.4, y: 4473.6), controlPoint1: CGPoint(x: 1758.8, y: 4686), controlPoint2: CGPoint(x: 2023.6, y: 4606.8))
    path.addCurve(to: CGPoint(x: 3160.7, y: 5222.1), controlPoint1: CGPoint(x: 2368.3, y: 4908.1), controlPoint2: CGPoint(x: 2731.9, y: 5222.1))
    path.addCurve(to: CGPoint(x: 3889.9, y: 4849.9), controlPoint1: CGPoint(x: 3451.2, y: 5222.1), controlPoint2: CGPoint(x: 3711.8, y: 5077.9))
    path.addCurve(to: CGPoint(x: 4483.1, y: 5010.5), controlPoint1: CGPoint(x: 4062.7, y: 4951.8), controlPoint2: CGPoint(x: 4265.9, y: 5010.5))
    path.addCurve(to: CGPoint(x: 5251, y: 4723.9), controlPoint1: CGPoint(x: 4778.8, y: 5010.5), controlPoint2: CGPoint(x: 5048.6, y: 4902.1))
    path.addCurve(to: CGPoint(x: 6372.5, y: 5245.2), controlPoint1: CGPoint(x: 5523.9, y: 5043), controlPoint2: CGPoint(x: 5925, y: 5245.2))
    path.addCurve(to: CGPoint(x: 7659.2, y: 4489.2), controlPoint1: CGPoint(x: 6921.5, y: 5245.2), controlPoint2: CGPoint(x: 7401.3, y: 4940.7))
    path.addCurve(to: CGPoint(x: 7778.3, y: 4499.1), controlPoint1: CGPoint(x: 7698, y: 4495.6), controlPoint2: CGPoint(x: 7737.8, y: 4499.1))
    path.addCurve(to: CGPoint(x: 8568.8, y: 3634.4), controlPoint1: CGPoint(x: 8215, y: 4499.1), controlPoint2: CGPoint(x: 8568.8, y: 4112))
    path.addCurve(to: CGPoint(x: 7778.3, y: 2769), controlPoint1: CGPoint(x: 8568.8, y: 3156.9), controlPoint2: CGPoint(x: 8215, y: 2769))
    path.addCurve(to: CGPoint(x: 7553.2, y: 2805.2), controlPoint1: CGPoint(x: 7700.1, y: 2769), controlPoint2: CGPoint(x: 7624.5, y: 2782.1))
    path.addCurve(to: CGPoint(x: 6564, y: 2223), controlPoint1: CGPoint(x: 7317.9, y: 2492.5), controlPoint2: CGPoint(x: 6966, y: 2275.8))
    path.addCurve(to: CGPoint(x: 4649, y: 336.4), controlPoint1: CGPoint(x: 6481.7, y: 1166.8), controlPoint2: CGPoint(x: 5655.7, y: 336.4))
    path.close()
    return path
    }
}
