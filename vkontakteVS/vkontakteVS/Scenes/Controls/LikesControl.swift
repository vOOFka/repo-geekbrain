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
    private var likeButton = LikeButton()
    private var likesLabel = UILabel()
    private var likesControlId: Int?
    weak var delegate: LikesControlDelegate?
    
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
        likeButton.likeState = currentPhoto.likeState
        
        
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
    }

}
