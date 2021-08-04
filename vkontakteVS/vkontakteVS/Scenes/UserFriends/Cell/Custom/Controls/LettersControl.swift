//
//  LettersControl.swift
//  vkontakteVS
//
//  Created by Admin on 03.08.2021.
//

import UIKit

//@IBDesignable
class LettersControl: UIControl {
    
    // MARK: Vars
    private var stackView = UIStackView()
    private var letterButtons = [UIButton]()
    private var letterArray = Friend.lettersFriends()
    var selectedLetter = (0, "") {
        didSet {
            sendActions(for: .valueChanged)
        }
    }
    
    override init(frame: CGRect) {
    //    let frame1 = CGRect(x: 0, y: 0, width: frame.size.width, height: 150)
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
        for letter in letterArray {
            let button = UIButton()
            button.setTitle(letter, for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.addTarget(self, action: #selector(clickLetterButton(_:)), for: .touchUpInside)
            letterButtons.append(button)
        }
        
        stackView = UIStackView(arrangedSubviews: letterButtons)

        stackView.axis = .horizontal
        //stackView.spacing = 2 //error constrain
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        self.addSubview(stackView)
    }
    
    @objc private func clickLetterButton(_ sender: UIButton) {
        guard let index = letterButtons.firstIndex(of: sender),
              let letter = letterButtons[index].titleLabel?.text else { return }
        print(index, letter)
        return selectedLetter = (index,letter)
    }
}
