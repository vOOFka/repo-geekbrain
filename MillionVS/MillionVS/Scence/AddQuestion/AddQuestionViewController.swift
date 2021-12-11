//
//  AddQuestionViewController.swift
//  MillionVS
//
//  Created by Home on 08.12.2021.
//

import UIKit

class AddQuestionViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak private var addQuestionScrollView: UIScrollView!
    @IBOutlet weak private var questionTextView: UITextView!
    @IBOutlet weak private var correctAnswerdTextField: UITextField!
    @IBOutlet weak private var wrongAnswerdOneTextField: UITextField!
    @IBOutlet weak private var wrongAnswerdTwoTextField: UITextField!
    @IBOutlet weak private var wrongAnswerdThreeTextField: UITextField!
    @IBOutlet weak private var appendButton: UIButton!
 
    private let questionCaretaker = QuestionsCaretaker()
    private var newQuestions: [Question] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        newQuestions = questionCaretaker.retrieveQuestions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        removeNotifications()
    }
    
    @IBAction private func tapAppendButton(_ sender: UIButton) {
        guard let question = questionTextView.text,
              let correctA = correctAnswerdTextField.text,
              let wrongOne = wrongAnswerdOneTextField.text,
              let wrongTwo = wrongAnswerdTwoTextField.text,
              let wrongThree = wrongAnswerdThreeTextField.text,
              !question.isEmpty, !correctA.isEmpty, !wrongOne.isEmpty, !wrongTwo.isEmpty, !wrongThree.isEmpty
        else {
            showAddError()
            return
        }
        var newQuestionAnwers = [Answer]()
        newQuestionAnwers.append(Answer(answer: correctA, type: .correct))
        newQuestionAnwers.append(Answer(answer: wrongOne, type: .wrong))
        newQuestionAnwers.append(Answer(answer: wrongTwo, type: .wrong))
        newQuestionAnwers.append(Answer(answer: wrongThree, type: .wrong))
        
        let newQuestion = Question(question: question, answers: newQuestionAnwers)
        newQuestions.append(newQuestion)
        questionCaretaker.save(questions: newQuestions)
        showAddMsg()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.addQuestionScrollView.endEditing(true)
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardShow (_ notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsert = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 10, right: 0)
        
        addQuestionScrollView.contentInset = contentInsert
        addQuestionScrollView.scrollIndicatorInsets = contentInsert
        addQuestionScrollView.scrollRectToVisible(appendButton.frame, animated: true)
    }
    
    @objc func keyboardHide () {
        addQuestionScrollView.contentInset = .zero
    }
    
    @objc func hideKeyboard () {
        self.addQuestionScrollView?.endEditing(true)
    }
    
    fileprivate func setupUI() {
        questionTextView.text = "Укажите вопрос который хотите задать"
        questionTextView.textColor = UIColor.lightGray
        questionTextView.delegate = self
        correctAnswerdTextField.delegate = self
        wrongAnswerdTwoTextField.delegate = self
        wrongAnswerdOneTextField.delegate = self
        wrongAnswerdThreeTextField.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Укажите вопрос который хотите задать"
            textView.textColor = UIColor.lightGray
        }
    }
    
    private func showAddError() {
        let alertMsg = UIAlertController(title: "Ошибка добавления", message: "Проверьте заполнение полей", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        alertMsg.addAction(closeAction)
        self.present(alertMsg, animated: true, completion: nil)
    }
    
    private func showAddMsg() {
        let alertMsg = UIAlertController(title: "Успешное добавление", message: "Вы успешно добавили новый вопрос", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        alertMsg.addAction(closeAction)
        self.present(alertMsg, animated: true, completion: nil)
    }
}
