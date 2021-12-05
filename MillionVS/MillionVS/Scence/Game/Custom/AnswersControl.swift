//
//  AnswersControl.swift
//  MillionVS
//
//  Created by Home on 03.12.2021.
//
import UIKit

//@IBDesignable
class AnswersControl: UIControl {
    
    // MARK: Vars
    private var stackView = UIStackView()
    private var answerButtons = [UIButton]()
    private var answers = [String]()
    var selectedAnswer = (0, "") {
        didSet {
            sendActions(for: .valueChanged)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControl(array: answers)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupControl(array: answers)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
   
    func setupControl(array answers:[String]) {
        stackView.removeFullyAllArrangedSubviews()
        stackView.removeFromSuperview()
        answerButtons.removeAll()
        
        for answer in answers {
            let button = UIButton()
            button.setTitle(answer, for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.backgroundColor = UIColor.random()
            button.contentHorizontalAlignment = .center
            button.titleLabel?.numberOfLines = 0
            button.addTarget(self, action: #selector(clickAnswerButton(_:)), for: .touchUpInside)
            answerButtons.append(button)
        }
        stackView = UIStackView(arrangedSubviews: answerButtons)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        self.addSubview(stackView)
    }
    
    @objc private func clickAnswerButton(_ sender: UIButton) {
        guard let index = answerButtons.firstIndex(of: sender),
              let answer = answerButtons[index].titleLabel?.text else { return }
        print(index, answer)
        return selectedAnswer = (index,answer)
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

extension UIStackView {
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
}
