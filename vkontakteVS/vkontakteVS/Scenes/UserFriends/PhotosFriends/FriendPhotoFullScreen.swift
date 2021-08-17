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
    private var propertyAnimator: UIViewPropertyAnimator!
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
        let indexOfCurrentPhoto = image.1
        var indexNextPhoto = 0
        
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
        let fromView = isChange ? currentPhotoImageView : nextPhotoImageView
        let toView = isChange ? nextPhotoImageView : currentPhotoImageView
        
       // toView!.image = photoArray[indexNextPhoto].photo
        
        let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        switch sender.state {
        case .began:
            propertyAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
                //fromView!.frame = fromView!.frame.offsetBy(dx: 0, dy: 100)
                fromView!.transform = CGAffineTransform(translationX: fromView!.frame.size.width / 2 , y: 0).concatenating(scale)
               // UIView.transition(from: fromView!, to: toView!, duration: 5, options: [.transitionCrossDissolve, .showHideTransitionViews])
            })
            propertyAnimator.startAnimation()
            propertyAnimator.pauseAnimation()
        case .changed:
            let translation = recognazer.translation(in: self.view)
            let percent = translation.x / 100
            let animationPercent = min(1, max(0, percent))
            propertyAnimator.fractionComplete = animationPercent
            print(animationPercent)
        case .ended:
            if propertyAnimator.fractionComplete > 50 {
                propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            } else {
                propertyAnimator.stopAnimation(true)
            }
        case .cancelled:
                propertyAnimator.stopAnimation(true)
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
