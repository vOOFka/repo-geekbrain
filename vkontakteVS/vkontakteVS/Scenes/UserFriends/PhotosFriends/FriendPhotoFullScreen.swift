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
            photoArray = currentFriend?.photos ?? [Photos]()
        }
    }
    private var photoArray = [Photos]()
    private var animator: UIViewPropertyAnimator!
    private let recognazer = UIPanGestureRecognizer()
    private var isChange = false
    private var defaultCenter = CGPoint(x: 0, y: 0)
    
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
        defaultCenter = currentPhotoImageView.center
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
        
        currentPhotoImageView.center = view.center
        nextPhotoImageView.center = view.center

        //image = (photoArray[indexNextPhoto].photo, indexNextPhoto)

        let translation = recognazer.translation(in: view)
        let scale = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
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
            })
            animator.startAnimation()
            animator.pauseAnimation()
        case .changed:
            // print("changed")
            let percent = abs(translation.x / 100)
            let animationPercent = min(1, max(0, percent))
            animator.fractionComplete = animationPercent
            print("defaultCenter: \(defaultCenter.x), translation.x: \(translation.x), percent: \(percent), animationPercent: \(animationPercent)")
        case .ended:
            print("ended")
            indexNextPhoto = whatNextIndexOfPhoto(index: indexOfCurrentPhoto, direction: sender.direction!)
            toView.image = photoArray[indexNextPhoto].photo
            
            if translation.x < -20 || translation.x > 20 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                UIView.transition(from: fromView, to: toView, duration: 2, options: [.transitionCrossDissolve, .showHideTransitionViews])
                isChange = !isChange
                
                
                fromView.alpha = 1
                toView.alpha = 0
                fromView.isHidden = false
                toView.isHidden = false
                fromView.center = view.center
                toView.center = view.center
            } else {
                animator.isReversed = true
                animator.startAnimation()
            }
        case .cancelled:
            print("cancelled")
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
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return currentPhotoImageView
    }
}
