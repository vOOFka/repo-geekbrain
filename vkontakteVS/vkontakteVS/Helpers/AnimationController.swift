//
//  AnimationController.swift
//  vkontakteVS
//
//  Created by Admin on 19.08.2021.
//

import UIKit

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let animationDuration: TimeInterval = 1
    private let animationType: AnimationType
    
    enum AnimationType {
        case present
        case dismiss
    }
    
    init(animationType: AnimationType) {
        self.animationType = animationType
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        fromViewController.view.frame = transitionContext.containerView.frame
        toViewController.view.frame = transitionContext.containerView.frame
        
        switch animationType {
        case .present:
            print("present")
            transitionContext.containerView.addSubview(toViewController.view)
            //presentAnimation(with: transitionContext, viewToAnimate: toViewController.view)
            presentAnimation90Degries(with: transitionContext, viewToAnimate: toViewController.view)
        case .dismiss:
            print("dismiss")
            transitionContext.containerView.addSubview(fromViewController.view)
            transitionContext.containerView.addSubview(toViewController.view)
            //dismissAnimation(with: transitionContext, viewToAnimate: toViewController.view)
            dismissAnimation90Degries(with: transitionContext, viewToAnimate: toViewController.view)
        }
        
    }
   
    func presentAnimation90Degries(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        viewToAnimate.layer.anchorPoint = CGPoint(x: 0, y: 0)
        viewToAnimate.frame = CGRect(x: 0, y: 0, width: viewToAnimate.frame.width, height: viewToAnimate.frame.height)
        viewToAnimate.transform = CGAffineTransform(rotationAngle: 1.8)
        
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            viewToAnimate.transform = .identity
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
        
    }

    func dismissAnimation90Degries(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        viewToAnimate.isHidden = false
        viewToAnimate.layer.anchorPoint = CGPoint(x: 1, y: 0)
        viewToAnimate.frame = CGRect(x: 0, y: 0, width: viewToAnimate.frame.width, height: viewToAnimate.frame.height)
        viewToAnimate.transform = CGAffineTransform(rotationAngle: -1.8)
        
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            viewToAnimate.transform = .identity
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
        
    }
}
