//
//  LikesControl.swift
//  vkontakteVS
//
//  Created by Admin on 30.07.2021.
//

import UIKit

//@IBDesignable
protocol LikesControlDelegate: AnyObject {
   func likeWasTap(at controlId: Int)
}

class LikesControl: UIControl {
    
    // MARK: Vars
    private var stackView = UIStackView()
    var likeButton = LikeButton()
    private var likesLabel = UILabel()
    private var likesControlId: Int?
    weak var delegate: LikesControlDelegate?
    public var heartWasPressed = { }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    func setupLikesUI(currentPhoto: RealmPhoto) {
        self.likesControlId = currentPhoto.id
        likeButton.addTarget(self, action: #selector(clickLikes(_:)), for: .touchUpInside)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.heightAnchor.constraint(equalTo: likeButton.widthAnchor, multiplier: 1/1).isActive = true
        
        likesLabel.text = String(currentPhoto.likes!)
        likesLabel.textColor = UIColor.black
        likesLabel.textAlignment = .center

        stackView = UIStackView(arrangedSubviews: [likesLabel, likeButton])

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        self.addSubview(stackView)
    }
    
    @objc private func clickLikes(_ sender: UIButton) {
        delegate?.likeWasTap(at: likesControlId!)
        likeButton.likeState.toggle()
        heartWasPressed()
        //Animation for tap like
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.5
        animation.fromValue = layer.transform
        animation.toValue = CATransform3DMakeRotation(.pi, 0, 1, 0)
        likeButton.layer.add(animation, forKey: nil)
    }

}
