//
//  FriendPhotoFullScreen.swift
//  vkontakteVS
//
//  Created by Home on 02.08.2021.
//

import UIKit

class FriendPhotoFullScreen: UIViewController {

    @IBOutlet weak private var photoFullScreenImage: UIImageView!
    @IBOutlet weak private var photoFullScreenScrollView: UIScrollView!
    var image: (UIImage?, Int) = (nil, 0)
    var currentFriend: Friend? {
        didSet{
            photoArray = currentFriend?.photos ?? [Photos]()
        }
    }
    var photoArray = [Photos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configuration for zooming photo
        setupPhotoFullScreenScrollView()
        // Configuration for listing photo
        setupSwipeRecognizer()
    }
    
    fileprivate func setupSwipeRecognizer() {
        let next = UISwipeGestureRecognizer()
        let back = UISwipeGestureRecognizer()
        next.direction = .left
        back.direction = .right
        view.addGestureRecognizer(next)
        view.addGestureRecognizer(back)
        next.addTarget(self, action: #selector(changePhotoFullScreenImage(_:)))
        back.addTarget(self, action: #selector(changePhotoFullScreenImage(_:)))
    }
    
    @objc private func changePhotoFullScreenImage(_ swipe: UISwipeGestureRecognizer) {
        let indexOfCurrentPhoto = image.1
        var indexNextPhoto = 0
        var reverseAnimations = false
        
        switch swipe.direction {
        case .left:
            indexNextPhoto = whatNextIndexOfPhoto(index: indexOfCurrentPhoto + 1)
        case .right:
            indexNextPhoto = whatNextIndexOfPhoto(index: indexOfCurrentPhoto - 1)
            reverseAnimations = true
        default:
            break
        }
        changePhotoAnimations(index: indexNextPhoto, reverse: reverseAnimations)
    }
    
    fileprivate func changePhotoAnimations(index i: Int, reverse: Bool) {
        let fromView = photoFullScreenImage!
        let toView = UIImageView(image: photoArray[i].photo)
        
        toView.frame.size = fromView.frame.size
        toView.contentMode = .scaleAspectFit
        toView.center.x = fromView.center.x + fromView.frame.size.width
        
        if reverse == false {
            UIView.animate(withDuration: 0.2,
                           delay: 0.2,
                           options: .curveLinear)
            {
                fromView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            } completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 0.2,
                               options: .curveLinear) {
                    toView.center.x = fromView.center.x
                }
                UIView.transition(from: fromView, to: toView,
                                  duration: 1,
                                  options: [.curveEaseIn, .transitionCrossDissolve ])
            }
        } else {
            toView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            UIView.animate(withDuration: 0.5, delay: 0.2,
                           options: .curveLinear) {
                fromView.center.x = toView.center.x
            } completion: { _ in
                toView.center.x = fromView.center.x - fromView.frame.size.width
                
                UIView.animate(withDuration: 0.2,
                               delay: 0.2,
                               options: .curveLinear)
                {
                    toView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                UIView.transition(from: fromView, to: toView,
                                  duration: 1,
                                  options: [.curveEaseIn, .transitionCrossDissolve ])
            }
        }
        photoFullScreenImage = toView
        image = (photoArray[i].photo, i)
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
        photoFullScreenImage.image = image.0
        photoFullScreenImage.contentMode = .scaleAspectFit
        //scroolview config
        photoFullScreenScrollView.contentSize = image.0?.size ?? view.bounds.size
        photoFullScreenScrollView.delegate = self
        photoFullScreenScrollView.minimumZoomScale = 1.0
        photoFullScreenScrollView.maximumZoomScale = 3.0
    }
}

extension FriendPhotoFullScreen: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoFullScreenImage
    }
}
