//
//  GameTableViewController.swift
//  MillionVS
//
//  Created by Home on 30.11.2021.
//

import UIKit

protocol GameDelegate: AnyObject {
    func didEndGame(withResult result: GameSession)
}

class GameTableViewController: UITableViewController {
    //MARK: Outlets
    @IBOutlet weak private var answersControl: AnswersControl!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var numberOfQuestionLabel: UILabel!
    @IBOutlet weak private var scoreLabel: UILabel!
    @IBOutlet weak private var persentCorrectAnswerdLabel: UILabel!
    
    //MARK: - Vars
    private var questions = Question.getQuestions()
    private var i = 0
    private let selectedDifficulty = Game.shared.selectedDifficulty
    private let gameSession = Game.shared.gameSession ?? GameSession()
    weak var gameDelegate: GameDelegate?
    private var showQuestionsStrategy: ShowQuestionsStrategy?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        choiceStrategy()
        letsPlay(some: questions[i])
        //watch press LettersControl
        answersControl.addTarget(self, action: #selector(answerWasChange(_:)), for: .valueChanged)
        //Add observer for watch correct answerds
        gameSession.correctAnswerdsObs.addObserver(self, options: [.new, .initial], closure: {
            [weak self] (correctAnsw, _)  in
            guard let self = self else { return }
            let persent = self.calculatePercent(value: Double(correctAnsw), fromValue: Double(self.questions.count))
            self.persentCorrectAnswerdLabel.text = "(\(persent)%)"
        })
    }
    
    @objc private func answerWasChange(_ control: AnswersControl) {
        let selectAnswer = control.selectedAnswer
        let answerType = questions[i].answers[selectAnswer.0].type
        if (answerType == .correct && i < questions.count - 1) {
            i += 1; gameSession.scores += 100000
            letsPlay(some: questions[i])
        } else {
            print("End of Game")
            gameSession.correctAnswerds = i
            gameSession.questionCount = questions.count
            self.gameDelegate?.didEndGame(withResult: gameSession)
        }
    }
    
    private func choiceStrategy() {
        switch self.selectedDifficulty {
        case .easy:
            showQuestionsStrategy = SequentialShowQuestionsStrategy()
        case .medium:
            showQuestionsStrategy = RandomShowQuestionsStrategy()
        }
        guard let sqs = showQuestionsStrategy else { return }
        questions = sqs.getQuestions(questions)
    }
    
    private func letsPlay(some question: Question) {
        questionLabel.text = question.question
        numberOfQuestionLabel.text = "Question: \(i + 1) of \(questions.count)"
        gameSession.correctAnswerdsObs.value = i
        scoreLabel.text = "\(gameSession.scores)"
        
        let answers = question.answers.map({ $0.answer })
        //Update custom UIControl
        answersControl.setupControl(array: answers)
    }
    
    fileprivate func calculatePercent(value: Double, fromValue: Double) -> Double {
        let val = value * 100
        return val / fromValue
    }
}

