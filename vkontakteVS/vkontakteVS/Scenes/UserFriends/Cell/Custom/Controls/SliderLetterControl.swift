//
//  SliderLetterControl.swift
//  vkontakteVS
//
//  Created by Home on 05.08.2021.
//

import UIKit

class SliderLetterControl: UIControl {

    // MARK: Vars
    private var stackView = UIStackView()
    private var letterSlider = UISlider()
    private var letterArray = Friend.lettersFriends()
    var selectedLetter = (0, "") {
        didSet {
            sendActions(for: .valueChanged)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControl()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupControl()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    private func setupControl() {
        
        stackView.addArrangedSubview(letterSlider)

        stackView.axis = .horizontal
        //stackView.spacing = 2 //error constrain
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        self.addSubview(stackView)
    }
    
//    @objc private func clickLetterButton(_ sender: UIButton) {
//        guard let index = letterButtons.firstIndex(of: sender),
//              let letter = letterButtons[index].titleLabel?.text else { return }
//        print(index, letter)
//        return selectedLetter = (index,letter)
//    }
}
