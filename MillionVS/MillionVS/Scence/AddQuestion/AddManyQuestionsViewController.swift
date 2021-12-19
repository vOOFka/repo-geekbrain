//
//  AddManyQuestionsViewController.swift
//  MillionVS
//
//  Created by Home on 12.12.2021.
//

import UIKit

class AddManyQuestionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let questionCaretaker = QuestionsCaretaker()
    private let builder = QuestionBuilder()
    private let builderManyQuestion = QuestionsBuilder()
    private var newQuestions: [Question] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if newQuestions.count == 0 {
            newQuestions.append(emptyQuestion())
        }
    }
    
    @IBAction func tapAppendBtn(_ sender: UIButton) {
        let oldQuestions = questionCaretaker.retrieveQuestions()
        for (index, _) in newQuestions.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            guard
                let questionInCell = checkQuestionInCell(indexCell: indexPath),
                let question = questionInCell.3
            else { return }
            builderManyQuestion.addQuestion(question)
        }
        //Save
        let questionsForSave = oldQuestions + builderManyQuestion.build()
        questionCaretaker.save(questions: questionsForSave)
        showAddMsg()
    }
    
    @IBAction func tapOneMoreQuestionBtn(_ sender: UIButton) {
        let indexPath = IndexPath(row: newQuestions.count - 1, section: 0)
        guard let questionInCell = checkQuestionInCell(indexCell: indexPath) else { return }
        
        builder.setQuestion(questionInCell.0)
        builder.setCorrectAnswer(questionInCell.1.answer)
        builder.setWrongAnswers(questionInCell.2)
        newQuestions.removeLast()
        newQuestions.append(builder.build())
        newQuestions.append(emptyQuestion())
        tableView.reloadData()
    }
}

extension AddManyQuestionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(AddManyQuestionsCell.self, for: indexPath)
        cell.configuration(indexPath.row + 1, newQuestions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 272.0
    }
}

extension AddManyQuestionsViewController {
    private func showAddError() {
        let alertMsg = UIAlertController(title: "Ошибка добавления", message: "Проверьте заполнение полей", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        alertMsg.addAction(closeAction)
        self.present(alertMsg, animated: true, completion: nil)
    }
    
    private func showAddMsg() {
        let alertMsg = UIAlertController(title: "Успешное добавление", message: "Вы успешно добавили \(builderManyQuestion.questions.count) новых вопросов", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        alertMsg.addAction(closeAction)
        self.present(alertMsg, animated: true, completion: nil)
    }
    
    private func emptyQuestion() -> Question {
        var question: Question
        var answers: [Answer] = []
        answers.append(Answer(answer: "", type: .correct))
        answers.append(Answer(answer: "", type: .wrong))
        answers.append(Answer(answer: "", type: .wrong))
        answers.append(Answer(answer: "", type: .wrong))
        question = Question(question: "", answers: answers)
        return question
    }
    
    private func checkQuestionInCell(indexCell indexPath: IndexPath) -> (String, Answer, [Answer], Question?)? {
        guard let cell = tableView.cellForRow(at: indexPath) as? AddManyQuestionsCell else { return nil }
        let questionInCell = cell.question
        guard
            let question = questionInCell?.question,
            let correctA = questionInCell?.answers.first(where: { $0.type == .correct }),
            let wrongAnswerds = questionInCell?.answers.filter({ $0.type == .wrong }),
            !question.isEmpty, !correctA.answer.isEmpty, wrongAnswerds.count == 3
        else {
            showAddError()
            return nil
        }
        guard !wrongAnswerds[0].answer.isEmpty, !wrongAnswerds[1].answer.isEmpty, !wrongAnswerds[2].answer.isEmpty
        else {
            showAddError()
            return nil
        }
        return (question, correctA, wrongAnswerds, questionInCell)
    }
}
