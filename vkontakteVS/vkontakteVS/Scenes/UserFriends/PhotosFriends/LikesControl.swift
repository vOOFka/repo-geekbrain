//
//  LikesControl.swift
//  vkontakteVS
//
//  Created by Admin on 30.07.2021.
//

import UIKit

class LikesControl: UIControl {
    
    // MARK: Vars
    private var stackView: UIStackView!
    private var likeButton = UIButton()
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
    
    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//        context.setFillColor(UIColor.red.cgColor)
//        context.fill(CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height))
        
    }
    
    private func setupLikesUI() {
        likeButton.backgroundColor = UIColor.black
        likeButton.sizeThatFits(CGSize(width: 20, height: 20))
        
        likesLabel.text = "0"
        likesLabel.textColor = UIColor.black
        likesLabel.textAlignment = .center
        
        stackView = UIStackView(arrangedSubviews: [likesLabel, likeButton])
        //stackView.spacing = 10 //error in console
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
    }
}
