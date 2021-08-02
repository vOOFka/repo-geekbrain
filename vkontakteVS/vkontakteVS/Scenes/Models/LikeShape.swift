//
//  Like.swift
//  vkontakteVS
//
//  Created by Home on 01.08.2021.
//

import UIKit

struct Like {
    static var shape: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 433.6, y: 67))
        path.addCurve(to: CGPoint(x: 341.3, y: 28.8), controlPoint1: CGPoint(x: 408.9, y: 42.3), controlPoint2: CGPoint(x: 376.2, y: 28.8))
        path.addCurve(to: CGPoint(x: 248.9, y: 67.1), controlPoint1: CGPoint(x: 306.4, y: 28.8), controlPoint2: CGPoint(x: 273.6, y: 42.4))
        path.addLine(to: CGPoint(x: 236, y: 80))
        path.addLine(to: CGPoint(x: 222.9, y: 66.9))
        path.addCurve(to: CGPoint(x: 130.4, y: 28.5), controlPoint1: CGPoint(x: 198.2, y: 42.2), controlPoint2: CGPoint(x: 165.3, y: 28.5))
        path.addCurve(to: CGPoint(x: 38.2, y: 66.7), controlPoint1: CGPoint(x: 95.6, y: 28.5), controlPoint2: CGPoint(x: 62.8, y: 42.1))
        path.addCurve(to: CGPoint(x: 0, y: 159.1), controlPoint1: CGPoint(x: 13.5, y: 91.4), controlPoint2: CGPoint(x: -0.1, y: 124.2))
        path.addCurve(to: CGPoint(x: 38.4, y: 251.4), controlPoint1: CGPoint(x: 0, y: 194), controlPoint2: CGPoint(x: 13.7, y: 226.7))
        path.addLine(to: CGPoint(x: 226.2, y: 439.2))
        path.addCurve(to: CGPoint(x: 235.7, y: 443.2), controlPoint1: CGPoint(x: 228.8, y: 441.8), controlPoint2: CGPoint(x: 232.3, y: 443.2))
        path.addCurve(to: CGPoint(x: 245.2, y: 439.3), controlPoint1: CGPoint(x: 239.1, y: 443.2), controlPoint2: CGPoint(x: 242.6, y: 441.9))
        path.addLine(to: CGPoint(x: 433.4, y: 251.8))
        path.addCurve(to: CGPoint(x: 471.7, y: 159.4), controlPoint1: CGPoint(x: 458.1, y: 227.1), controlPoint2: CGPoint(x: 471.7, y: 194.3))
        path.addCurve(to: CGPoint(x: 433.6, y: 67), controlPoint1: CGPoint(x: 471.8, y: 124.5), controlPoint2: CGPoint(x: 458.3, y: 91.7))
        path.close()       
    return path
    }
}
