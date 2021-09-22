//
//  FriendPhotoFullScreen.swift
//  vkontakteVS
//
//  Created by Home on 02.08.2021.
//

import UIKit
import Kingfisher
import RealmSwift

class FriendPhotoFullScreen: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak private var currentPhotoImageView: UIImageView!
    @IBOutlet weak private var nextPhotoImageView: UIImageView!
    @IBOutlet weak private var photoFullScreenScrollView: UIScrollView!
    //MARK: Properties
    private struct Properties {
        static let networkService = NetworkServiceImplimentation()
        static let realmService: RealmService = RealmServiceImplimentation()
        //Choice size download photo
        static let size = sizeTypeRealmEnum.max
        static var photosItems: Results<RealmPhoto>!
        static var image: (UIImage?, Int)?
        static var animator: UIViewPropertyAnimator!
        static let recognazer = UIPanGestureRecognizer()
        static var isChange = false
    }
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Configuration
        nextPhotoImageView.alpha = 0
        downloadPhotoFromWeb(currentPhotoIndex: Properties.image?.1 ?? 0, anotherPhoto: Properties.photosItems)
        downloadAllPhotosFromWeb()
        // Configuration for zooming photo
        setupPhotoFullScreenScrollView()
        // Configuration for listing photo
        setupPanRecognizer()
    }
    //MARK: - Functions
    func configuration(selectPhotoId: Int, anotherPhoto: Results<RealmPhoto>!) {
        guard let currentPhotoIndex = anotherPhoto.firstIndex(where: { $0.id == selectPhotoId }) else { return }
        Properties.image = (nil, currentPhotoIndex)
        Properties.photosItems = anotherPhoto
    }
    //Загрузка в БД
    fileprivate func pushToRealmDB(currentPhoto: RealmPhoto, image: UIImage) {
        do {
            let realm = try Realm()
            guard let allItems = realm.objects(RealmPhoto.self).first(where: { $0.id == currentPhoto.id }),
                  let item =  allItems.sizes.first(where: { $0.type == Properties.size }),
                  let image = image.jpegData(compressionQuality: 80.0) else { return }
            try realm.write {
                item.setValue(image, forKey: "image")
            }
        } catch (let error) {
            print(error)
        }
    }
    
    fileprivate func downloadPhotoFromWeb(currentPhotoIndex: Int, anotherPhoto: Results<RealmPhoto>!) {
        if (currentPhotoImageView != nil) {
            let photoFromDB = anotherPhoto[currentPhotoIndex]
            let photoSizeFromDB = photoFromDB.sizes.first(where: { $0.type == Properties.size })?.image
            if photoSizeFromDB == nil {
                guard let url = photoFromDB.sizes.first(where: { $0.type == Properties.size })?.urlPhoto else { return }
                print("Загрузка из сети \(currentPhotoIndex)")
                currentPhotoImageView.kf.setImage(with: URL(string: url), completionHandler: { [weak self] result in
                    switch result {
                    case .success(let image):
                        let image = image.image as UIImage
                        self?.pushToRealmDB(currentPhoto: photoFromDB, image: image)
                    case .failure(let error):
                        print(error)
                    }
                })
            }
            print("Загрузка из БД")
            guard let image = UIImage(data: photoSizeFromDB ?? Data()) else { return }
            currentPhotoImageView.image = image
            Properties.image = (image, currentPhotoIndex)
            Properties.photosItems = anotherPhoto
        }
    }
    
    fileprivate func downloadAllPhotosFromWeb() {
        for (i,item) in Properties.photosItems.enumerated() {
            if (item.sizes.first(where: { $0.type == Properties.size })?.image) != nil {
                let url = item.sizes.first(where: { $0.type == Properties.size })?.urlPhoto
                if url != nil {
                    print("Загрузка из сети \(i)")
                    _ = UIImageView().kf.setImage(with: URL(string: url!), completionHandler: { [weak self] result in
                        switch result {
                        case .success(let image):
                            let image = image.image as UIImage
                            self?.pushToRealmDB(currentPhoto: item, image: image)
                        case .failure(let error):
                            print(error)
                        }
                    })
                }
            }
        }
    }
    
    fileprivate func setupPanRecognizer() {
        self.view.addGestureRecognizer(Properties.recognazer)
        Properties.recognazer.addTarget(self, action: #selector(onPan(_:)))
    }
    
    @objc private func onPan(_ sender: UIPanGestureRecognizer) {
        let indexOfCurrentPhoto = Properties.image!.1
        var indexNextPhoto = 0

        let fromView = Properties.isChange ? nextPhotoImageView! : currentPhotoImageView!
        let toView = Properties.isChange ? currentPhotoImageView! : nextPhotoImageView!

        let translation = Properties.recognazer.translation(in: view)
        let scaleOut = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let scaleIn = CGAffineTransform(scaleX: 1, y: 1)
        
        if sender.direction == .down {
           // self.navigationController?.popViewController(animated: true)
        }
        
        let offsetXFromView = fromView.frame.size.width
        var offsetXToView: CGFloat = 0
        toView.alpha = 0
        
        switch sender.state {
        case .began:
            //print("began")
            if sender.direction == .right {
                offsetXToView = -offsetXFromView
            } else if sender.direction == .left {
                offsetXToView = offsetXFromView
            }
            toView.transform = CGAffineTransform(translationX: offsetXToView, y: 0).concatenating(scaleOut)
            
            Properties.animator = UIViewPropertyAnimator(duration: 0.6, curve: .easeInOut, animations: {
                if sender.direction == .right {
                    fromView.transform = CGAffineTransform(translationX: offsetXFromView, y: 0).concatenating(scaleOut)
                    toView.transform = CGAffineTransform(translationX: 0, y: 0).concatenating(scaleIn)
                }
                else if sender.direction == .left {
                    fromView.transform = CGAffineTransform(translationX: -offsetXFromView, y: 0).concatenating(scaleOut)
                    toView.transform = CGAffineTransform(translationX: 0, y: 0).concatenating(scaleIn)
                }
            })
            Properties.animator.startAnimation()
            Properties.animator.pauseAnimation()
        case .changed:
            // print("changed")
            let percent = abs(translation.x / 100)
            let animationPercent = min(1, max(0, percent))
            Properties.animator.fractionComplete = animationPercent
            //print("translation.x: \(translation.x), percent: \(percent), animationPercent: \(animationPercent)")
        case .ended:
            //print("ended")
            if translation.x < -20 || translation.x > 10 {
                indexNextPhoto = whatNextIndexOfPhoto(index: indexOfCurrentPhoto, direction: sender.direction!)
                let currentImgSize = Properties.photosItems[indexNextPhoto].sizes.first(where: { $0.type == Properties.size })
                let currentImgData = currentImgSize?.image
                Properties.image = (UIImage(data: currentImgData ?? Data()), indexNextPhoto)
                if Properties.image?.0 == nil {
                    downloadPhotoFromWeb(currentPhotoIndex: indexNextPhoto, anotherPhoto: Properties.photosItems)
                }
                toView.image = Properties.image!.0
//                DispatchQueue.main.async {
//                    let url = currentImgSize.urlPhoto
//                    toView.kf.setImage(with: URL(string: url))
//                }
                Properties.animator.continueAnimation(withTimingParameters: nil, durationFactor: 2)
                UIView.animate(withDuration: 0.8, delay: 0.5,
                               options: .curveEaseOut, animations: {
                                toView.alpha = 1
                                fromView.alpha = 0
                               })
                Properties.isChange = !Properties.isChange
            } else {
                Properties.animator.isReversed = true
                Properties.animator.startAnimation()
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
        
        if i > (Properties.photosItems.count - 1) {
            i = 0
        } else if i < 0 {
            i = Properties.photosItems.count - 1
        }
        return i
    }
    
    private func setupPhotoFullScreenScrollView() {
        //scroolview config
        photoFullScreenScrollView.contentSize = currentPhotoImageView.image?.size ?? view.bounds.size
        photoFullScreenScrollView.delegate = self
        photoFullScreenScrollView.minimumZoomScale = 1.0
        photoFullScreenScrollView.maximumZoomScale = 3.0
    }
}

extension FriendPhotoFullScreen: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        Properties.isChange ? nextPhotoImageView! : currentPhotoImageView!
    }
}
