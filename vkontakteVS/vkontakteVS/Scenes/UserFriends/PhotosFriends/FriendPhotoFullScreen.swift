//
//  FriendPhotoFullScreen.swift
//  vkontakteVS
//
//  Created by Home on 02.08.2021.
//

import UIKit

class FriendPhotoFullScreen: UIViewController {

    @IBOutlet weak private var currentPhotoImageView: UIImageView!
    @IBOutlet weak private var nextPhotoImageView: UIImageView!
    @IBOutlet weak private var photoFullScreenScrollView: UIScrollView!
    
    var image: (UIImage?, Int) = (nil, 0)
    var currentFriend: Friend? {
        didSet{
            photoArray = currentFriend?.photos ?? [Photos]()
        }
    }
    private var photoArray = [Photos]()
    private var animator: UIViewPropertyAnimator!
    private let recognazer = UIPanGestureRecognizer()
    private var isChange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configuration for zooming photo
        setupPhotoFullScreenScrollView()
        // Configuration for listing photo
        setupPanRecognizer()
    }
    
    fileprivate func setupPanRecognizer() {
        self.view.addGestureRecognizer(recognazer)
        recognazer.addTarget(self, action: #selector(onPan(_:)))
    }
    
    @objc func onPan(_ sender: UIPanGestureRecognizer) {
       // let indexOfCurrentPhoto = image.1
        //var indexNextPhoto = 0
        let defaultCenter = currentPhotoImageView.center
        
//        switch sender.direction {
//        case .left:
//            indexNextPhoto = whatNextIndexOfPhoto(index: indexOfCurrentPhoto + 1)
//        case .right:
//            indexNextPhoto = whatNextIndexOfPhoto(index: indexOfCurrentPhoto - 1)
//            //reverseAnimations = true
//        default:
//            break
//        }
//        image = (photoArray[indexNextPhoto].photo, indexNextPhoto)
        
        isChange = !isChange
        let fromView = isChange ? currentPhotoImageView! : nextPhotoImageView!
     //   let toView = isChange ? nextPhotoImageView! : currentPhotoImageView!
        
       // toView!.image = photoArray[indexNextPhoto].photo
       let translation = recognazer.translation(in: view)
       let scale = CGAffineTransform(scaleX: 0.95, y: 0.95)
       //let bluer
        
        switch sender.state {
        case .began:
            print("began")
            animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
                if sender.direction == .right {
                    fromView.transform = CGAffineTransform(translationX: fromView.frame.size.width + fromView.frame.size.width, y: 0).concatenating(scale)
                }
                else if sender.direction == .left {
                    fromView.transform = CGAffineTransform(translationX: -fromView.frame.size.width, y: 0).concatenating(scale)
                }
               // UIView.transition(from: fromView, to: toView, duration: 5, options: [.transitionCrossDissolve, .showHideTransitionViews])
            })
            animator.startAnimation()
            animator.pauseAnimation()
        case .changed:
           // print("changed")
            
           // someAnimation(with: translation)
            //fromView.transform = CGAffineTransform(translationX: translation.x, y: 0).concatenating(scale)
            
            //fromView.center = CGPoint(x: newX, y: 0)
            //recognazer.setTranslation(CGPoint.zero, in: self.view)
            
            let percent = abs(translation.x / 100)
            let animationPercent = min(1, max(0, percent))
            animator.fractionComplete = animationPercent
            print("defaultCenter: \(defaultCenter.x), translation.x: \(translation.x), percent: \(percent), animationPercent: \(animationPercent)")
        case .ended:
            print("ended")
            //left
            if translation.x < -20 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
//                UIView.animate(withDuration: 0.2, animations: {
//                    fromView.center.x = -fromView.frame.size.width
//                })
            }
            //right
            else if translation.x > 20 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
//                UIView.animate(withDuration: 0.2, animations: {
//                    fromView.center.x = fromView.frame.size.width + fromView.frame.size.width
//                })
            }
            animator.stopAnimation(true)
            UIView.animate(withDuration: 0, delay: 1, options: [], animations: {
                fromView.transform = .identity
                fromView.center = defaultCenter
            })
        case .cancelled:
            print("cancelled")
           // propertyAnimator.fractionComplete = 0
           // propertyAnimator.stopAnimation(true)
        default:
            break
        }
        
//        switch sender.direction {
//        case .left:
//            indexNextPhoto = whatNextIndexOfPhoto(index: indexOfCurrentPhoto + 1)
//            //nextPhotoImageView.image = photoArray[indexNextPhoto].photo
//        case .right:
//            indexNextPhoto = whatNextIndexOfPhoto(index: indexOfCurrentPhoto - 1)
//            //nextPhotoImageView.image = photoArray[indexNextPhoto].photo
//            reverseAnimations = true
//        default:
//            break
//        }
//        print("\(indexNextPhoto)")
        //changePhotoAnimations(index: indexNextPhoto, reverse: reverseAnimations)

    }
    
    fileprivate func changePhotoAnimations(index i: Int) {//, reverse: Bool) {

        
//        if reverse == false {
//            UIView.animate(withDuration: 0.2,
//                           delay: 0.2,
//                           options: .curveLinear)
//            {
//                fromView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//            } completion: { _ in
//                UIView.animate(withDuration: 0.5, delay: 0.2,
//                               options: .curveLinear) {
//                    toView.center.x = fromView.center.x
//                }
//                UIView.transition(from: fromView, to: toView,
//                                  duration: 1,
//                                  options: [.curveEaseIn, .transitionCrossDissolve ])
//            }
//        } else {
//            toView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//
//            UIView.animate(withDuration: 0.5, delay: 0.2,
//                           options: .curveLinear) {
//                fromView.center.x = toView.center.x
//            } completion: { _ in
//                toView.center.x = fromView.center.x - fromView.frame.size.width
//
//                UIView.animate(withDuration: 0.2,
//                               delay: 0.2,
//                               options: .curveLinear)
//                {
//                    toView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                }
//                UIView.transition(from: fromView, to: toView,
//                                  duration: 1,
//                                  options: [.curveEaseIn, .transitionCrossDissolve ])
//            }
//        }
//        currentPhotoImageView = toView
//        image = (photoArray[i].photo, i)
    }
    
    private func whatNextIndexOfPhoto(index: Int) -> Int {
        if index > (photoArray.count - 1) {
           return 0
        } else if index < 0 {
            return photoArray.count - 1
        }
        return index
    }
    
    private func setupPhotoFullScreenScrollView() {
        //image config
        currentPhotoImageView.image = image.0
        currentPhotoImageView.contentMode = .scaleAspectFit
        //scroolview config
        photoFullScreenScrollView.contentSize = image.0?.size ?? view.bounds.size
        photoFullScreenScrollView.delegate = self
        photoFullScreenScrollView.minimumZoomScale = 1.0
        photoFullScreenScrollView.maximumZoomScale = 3.0
    }
}

extension FriendPhotoFullScreen: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return currentPhotoImageView
    }
}
