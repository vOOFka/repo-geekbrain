//
//  AddManyQuestionsCell.swift
//  MillionVS
//
//  Created by Home on 12.12.2021.
//

import UIKit

class AddManyQuestionsCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak private var numberOfQuestion: UILabel!
    @IBOutlet weak private var questionTextField: UITextField!
    @IBOutlet weak private var correctAnswerdTextField: UITextField!
    @IBOutlet weak private var wrongAnswerdOneTextField: UITextField!
    @IBOutlet weak private var wrongAnswerdTwoTextField: UITextField!
    @IBOutlet weak private var wrongAnswerdThreeTextField: UITextField!
    
    public var question: Question?
    private let builder = QuestionBuilder()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configuration(_ num: Int, _ question: Question?) {
        questionTextField.delegate = self
        correctAnswerdTextField.delegate = self
        wrongAnswerdOneTextField.delegate = self
        wrongAnswerdTwoTextField.delegate = self
        wrongAnswerdThreeTextField.delegate = self
        
        self.question = question
        numberOfQuestion.text = "Number of question: \(num)"
        questionTextField.text = self.question?.question
        correctAnswerdTextField.text = self.question?.answers.first(where: { $0.type == .correct })?.answer
        guard let wrongAnswerds = question?.answers.filter({ $0.type == .wrong }) else { return }
        wrongAnswerdOneTextField.text = wrongAnswerds[0].answer
        wrongAnswerdTwoTextField.text = wrongAnswerds[1].answer
        wrongAnswerdThreeTextField.text = wrongAnswerds[2].answer
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case questionTextField:
            builder.setQuestion(questionTextField.text ?? "")
        case correctAnswerdTextField:
            builder.setCorrectAnswer(correctAnswerdTextField.text ?? "")
        case wrongAnswerdOneTextField, wrongAnswerdTwoTextField, wrongAnswerdThreeTextField:
            var wa = [Answer]()
            wa.append(Answer(answer: wrongAnswerdOneTextField.text ?? "", type: .wrong))
            wa.append(Answer(answer: wrongAnswerdTwoTextField.text ?? "", type: .wrong))
            wa.append(Answer(answer: wrongAnswerdThreeTextField.text ?? "", type: .wrong))
            builder.setWrongAnswers(wa)
        default:
            break
        }
        self.question = builder.build()
    }
}
