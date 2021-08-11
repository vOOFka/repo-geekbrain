//
//  TransparancyCircleView.swift
//  vkontakteVS
//
//  Created by Admin on 11.08.2021.
//

import UIKit

class TransparancyCircleView: UIView {

    var circleArray = [UIView(), UIView(), UIView()]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        circleArray = [UIView(), UIView(), UIView()]
        
        for circle in circleArray {
            circle.frame = CGRect(x: -35, y: 5, width: 30, height: 30)
            circle.layer.cornerRadius = 15
            circle.backgroundColor = .white
            circle.alpha = 0
            addSubview(circle)
        }
    }
    
    func animate() {
        for _ in (0...5) {
            var delay: Double = 0
            for circle in circleArray {
                animateCircle(circle, delay: delay)
                delay += 0.95
            }
            sleep(1)
        }
    }
    
    func animateCircle(_ circle: UIView, delay: Double) {
        UIView.animate(withDuration: 0.8, delay: delay, options: .curveLinear, animations: {
            circle.alpha = 1
            circle.frame = CGRect(x: 0, y: 5, width: 30, height: 30)
        }) { (completed) in
            UIView.animate(withDuration: 0.8, delay: 0, options: .curveLinear, animations: {
                circle.frame = CGRect(x: 45, y: 5, width: 30, height: 30)
            }) { (completed) in
                UIView.animate(withDuration: 0.8, delay: 0, options: .curveLinear, animations: {
                    circle.alpha = 0
                    circle.frame = CGRect(x: 90, y: 5, width: 30, height: 30)
                }) { (completed) in
                    UIView.animate(withDuration: 0.8, delay: 0, options: .curveLinear, animations: {
                        circle.frame = CGRect(x: -30, y: 5, width: 30, height: 30)
                        self.animateCircle(circle, delay: 0)
                    })
                }
            }
        }
    }
}
