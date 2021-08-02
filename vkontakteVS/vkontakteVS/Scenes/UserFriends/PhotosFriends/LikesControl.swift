//
//  LikesControl.swift
//  vkontakteVS
//
//  Created by Admin on 30.07.2021.
//

import UIKit

@IBDesignable
class LikesControl: UIControl {
    
    // MARK: Vars
    private var stackView = UIStackView()
    private var likeButton = LikeButton()
    private var likesLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLikesUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLikesUI()
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    private func setupLikesUI() {
        likeButton.addTarget(self, action: #selector(clickLikes(_:)), for: .touchUpInside)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.heightAnchor.constraint(equalTo: likeButton.widthAnchor, multiplier: 1/1).isActive = true
        
        likesLabel.text = "0"
        likesLabel.textColor = UIColor.black
        likesLabel.textAlignment = .center

        stackView = UIStackView(arrangedSubviews: [likesLabel, likeButton])

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        self.addSubview(stackView)
    }
    
    @objc private func clickLikes(_ sender: UIButton) {
        var likes = Int(likesLabel.text ?? "0")
        
        if likeButton.likeState == false {
            likes! = likes! + 1
        } else {
            likes! = likes! - 1
        }
        likeButton.likeState = !likeButton.likeState
        likesLabel.text = String(likes!)
    }

}
