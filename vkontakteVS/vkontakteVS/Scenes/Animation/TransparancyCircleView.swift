//
//  TransparancyCircleView.swift
//  vkontakteVS
//
//  Created by Admin on 11.08.2021.
//

import UIKit

class TransparancyCircleView: UIView {

    private var circleArray = [UIView(), UIView(), UIView()]
    
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
        circleArray = [UIView(), UIView(), UIView()]
        
        for circle in circleArray {
            circle.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            circle.layer.cornerRadius = 10
            circle.backgroundColor = .white
            circle.alpha = 0
            addSubview(circle)
        }
    }
    
    func animate() {
            var delay: Double = 0
            for circle in circleArray {
                animateCircle(circle, delay: delay)
                delay += 1.0
            }
    }
    
    private func animateCircle(_ circle: UIView, delay: Double) {
        UIView.animate(withDuration: 1.0, delay: delay, options: .curveEaseInOut, animations: {
            circle.alpha = 1
            circle.layer.cornerRadius = 15
            circle.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        }) { (completed) in
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                circle.frame = CGRect(x: 40, y: 0, width: 30, height: 30)
            }) { (completed) in
                UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                    circle.alpha = 0
                    circle.layer.cornerRadius = 10
                    circle.frame = CGRect(x: 80, y: 0, width: 20, height: 20)
                }) { (completed) in
                    UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                        circle.frame = CGRect(x: -30, y: 0, width: 20, height: 20)
                        self.animateCircle(circle, delay: 0)
                    })
                }
            }
        }
    }
}
