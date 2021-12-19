//
//  QuestionBuilder.swift
//  MillionVS
//
//  Created by Home on 12.12.2021.
//

import Foundation

class QuestionBuilder {
    private(set) var question: String = ""
    private(set) var correctAnswer: Answer = Answer(answer: "", type: .correct)
    private(set) var wrongAnswers: [Answer] = []
    
    func build() -> Question {
        var answers: [Answer] = []
        answers.append(correctAnswer)
        answers += wrongAnswers
        return Question(question: question, answers: answers)
    }
    
    func setQuestion(_ question: String) {
        self.question = question
    }
    
    func setCorrectAnswer(_ answer: String) {
        self.correctAnswer = Answer(answer: answer, type: .correct)
    }
    
    func setWrongAnswer(_ answer: String) {
        if !wrongAnswers.contains(where: { $0.answer == answer }) {
            self.wrongAnswers.append(Answer(answer: answer, type: .wrong))
        }
    }
    
    func setWrongAnswers(_ answers: [Answer]) {
        if answers.count == 3 {
            self.wrongAnswers = answers
        }
    }
}
