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
    private var letters = [String]()
    var selectedLetter = (0, "") {
        didSet {
            sendActions(for: .valueChanged)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControl(array: letters)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupControl(array: letters)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
   
    func setupControl(array letters:[String]) {
        var letters = letters
        
        for letter in letters {
            let button = UIButton()
            button.setTitle(letter, for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.backgroundColor = UIColor.random()
            button.addTarget(self, action: #selector(clickLetterButton(_:)), for: .touchUpInside)
            letterButtons.append(button)
        }
        
        stackView = UIStackView(arrangedSubviews: letterButtons)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        //For the moving choice
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(trackLetterButton(_:)))
        stackView.addGestureRecognizer(recognizer)
        
        self.addSubview(stackView)
    }

    @objc private func trackLetterButton(_ press: UIPanGestureRecognizer) {
        let location = press.location(in: self.stackView)
        whatIsTheButton(location: location)
    }
    
    func whatIsTheButton(location: CGPoint) {
        for (index, button) in letterButtons.enumerated() {
            let frame = button.convert(button.bounds, to: self.stackView)
            if frame.contains(location) {
                guard let letter = letterButtons[index].titleLabel?.text else { return }
                print(index, letter)
                return selectedLetter = (index,letter)
            }
        }
    }
    
    @objc private func clickLetterButton(_ sender: UIButton) {
        guard let index = letterButtons.firstIndex(of: sender),
              let letter = letterButtons[index].titleLabel?.text else { return }
        print(index, letter)
        return selectedLetter = (index,letter)
    }
}

extension CGFloat {
    static func randomColor() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .randomColor(), green: .randomColor(), blue: .randomColor(), alpha: 0.5)
    }
}
