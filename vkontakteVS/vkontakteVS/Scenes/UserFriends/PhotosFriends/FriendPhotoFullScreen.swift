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
    
    var image: (UIImage?, Int)?
    var currentFriend: Friend? {
        didSet{
            photoArray = [Photos]()
        }
    }
    private var photoArray = [Photos]()
    private var animator: UIViewPropertyAnimator!
    private let recognazer = UIPanGestureRecognizer()
    private var isChange = false
       
    override func viewDidLoad() {
        super.viewDidLoad()
        //Configuration
        setup()
        // Configuration for zooming photo
        setupPhotoFullScreenScrollView()
        // Configuration for listing photo
        setupPanRecognizer()
    }
    
    fileprivate func setup() {
        currentPhotoImageView.image = image!.0
        nextPhotoImageView.alpha = 0
    }
    
    fileprivate func setupPanRecognizer() {
        self.view.addGestureRecognizer(recognazer)
        recognazer.addTarget(self, action: #selector(onPan(_:)))
    }
    
    @objc func onPan(_ sender: UIPanGestureRecognizer) {
        let indexOfCurrentPhoto = image!.1
        var indexNextPhoto = 0

        let fromView = isChange ? nextPhotoImageView! : currentPhotoImageView!
        let toView = isChange ? currentPhotoImageView! : nextPhotoImageView!

        let translation = recognazer.translation(in: view)
        let scaleOut = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let scaleIn = CGAffineTransform(scaleX: 1, y: 1)
        
        if sender.direction == .down {
            self.navigationController?.popViewController(animated: true)
        }
        
        let offsetXFromView = fromView.frame.size.width
        var offsetXToView: CGFloat = 0
        toView.alpha = 0
        
        switch sender.state {
        case .began:
            print("began")
            if sender.direction == .right {
                offsetXToView = -offsetXFromView
            } else if sender.direction == .left {
                offsetXToView = offsetXFromView
            }
            toView.transform = CGAffineTransform(translationX: offsetXToView, y: 0).concatenating(scaleOut)
            
            animator = UIViewPropertyAnimator(duration: 0.6, curve: .easeInOut, animations: {
                if sender.direction == .right {
                    fromView.transform = CGAffineTransform(translationX: offsetXFromView, y: 0).concatenating(scaleOut)
                    toView.transform = CGAffineTransform(translationX: 0, y: 0).concatenating(scaleIn)
                }
                else if sender.direction == .left {
                    fromView.transform = CGAffineTransform(translationX: -offsetXFromView, y: 0).concatenating(scaleOut)
                    toView.transform = CGAffineTransform(translationX: 0, y: 0).concatenating(scaleIn)
                }
            })
            animator.startAnimation()
            animator.pauseAnimation()
        case .changed:
            // print("changed")
            let percent = abs(translation.x / 100)
            let animationPercent = min(1, max(0, percent))
            animator.fractionComplete = animationPercent
            print("translation.x: \(translation.x), percent: \(percent), animationPercent: \(animationPercent)")
        case .ended:
            print("ended")
            if translation.x < -20 || translation.x > 10 {
                indexNextPhoto = whatNextIndexOfPhoto(index: indexOfCurrentPhoto, direction: sender.direction!)
                image = (photoArray[indexNextPhoto].photo, indexNextPhoto)
                toView.image = photoArray[indexNextPhoto].photo
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 3)
                UIView.animate(withDuration: 0.8, delay: 0,
                               options: .curveEaseOut, animations: {
                                toView.alpha = 1
                                fromView.alpha = 0
                               })
                isChange = !isChange
            } else {
                animator.isReversed = true
                animator.startAnimation()
            }
        default:
            break
        }
    }
    
    private func whatNextIndexOfPhoto(index: Int, direction: Direction) -> Int {
        var i = index
        
        if direction == .right {
            i = i - 1
        } else {
            i = i + 1
        }
        
        if i > (photoArray.count - 1) {
            i = 0
        } else if i < 0 {
            i = photoArray.count - 1
        }
        return i
    }
    
    private func setupPhotoFullScreenScrollView() {
        //scroolview config
        photoFullScreenScrollView.contentSize = image!.0?.size ?? view.bounds.size
        photoFullScreenScrollView.delegate = self
        photoFullScreenScrollView.minimumZoomScale = 1.0
        photoFullScreenScrollView.maximumZoomScale = 3.0
    }
}

extension FriendPhotoFullScreen: UIScrollViewDelegate {
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        isChange ? nextPhotoImageView! : currentPhotoImageView!
    }
}
